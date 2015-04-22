require "net/pop"

class EmailBounceJob < ActiveJob::Base
  queue_as :default
  
  # reschedule job
  after_perform do |job|
    self.class.set(wait: 3600).perform_later
  end
  
  # do the task
  def perform(*args)
    @logger = Logger.new(Rails.root.join("log", "bounce.log"))
    @dry_run = false
    
    begin
      Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
      Net::POP3.start('pinto.tampahost.net', 995, 'deals', 'deals321user') do |pop|

        pop.each_mail do |mail|
          msg = Mail.new(mail.pop)
          processed = false
          processed ||= unsubscribe(msg)
          processed ||= bounce(msg)
          processed ||= feedback_loop(msg)
          mail.delete if (processed && !@dry_run)
        end

      end
    rescue => e
      @logger.error e
    end
  end

  # handle bounced emails
  def bounce(msg)
    to = msg.to.to_s

    # returned address in VERP format implies message bounced
    if !msg.parts.any? { |x| x.content_type == "message/feedback-report" } && to.include?("=") && to.include?("+")
      address = to.split("@")[0].split("+")[1].sub("=", "@")
      if msg.delivery_status_report? && msg.delivery_status_part
        error = msg.delivery_status_part.body.to_s
      else
        error = msg.body.to_s
      end

      @logger.info "#{address} bounced"
      s = EmailSubscriber.find_by(email: address)
      s.update_attributes(bounces: s.bounces+1, last_error: error) unless (s.nil? || @dry_run)

      line = msg.to_s.split("\n").find { |x| x.start_with?("X-Rhombus-Blast-UUID:") }
      unless line.nil?
        uuid = line.split(":")[1].strip
        EmailBlast.where(uuid: uuid).update_all("bounces=bounces+1") unless @dry_run
      end

      return true
    end

    false
  end

  # handle abuse report (FBL) as indicated by presence of 'message/feedback-report'
  def feedback_loop(msg)

    fbl = msg.parts.find { |x| x.content_type == "message/feedback-report" }
    unless fbl.nil?

      line = msg.to_s.split("\n").find { |x| x.start_with?("X-Rhombus-Subscriber-UUID:") }
      unless line.nil?
        uuid = line.split(":")[1].strip
        s = EmailSubscriber.find_by(uuid: uuid)
        unless s.nil?
          s.update_attributes(reported_spam: true, last_error: fbl.body.to_s) unless @dry_run
          @logger.info s.email + " reported spam"
          return true
        end
      end

    end

    false
  end

  # handle unsubscribe request where Subject: list-unsubscribe-id
  def unsubscribe(msg)
    false
  end
  
end
