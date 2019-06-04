class EmailSubscribersController < ApplicationController

  def create  
    res = true
    @email_subscriber = EmailSubscriber.find_or_initialize_by(email: email_subscriber_params[:email])
    @email_subscriber.update_attributes(opted_out: false, reported_spam: false, bounces: 0)
    @email_subscriber.update_attributes(ip_address: request.remote_ip, uuid: SecureRandom.uuid) unless @email_subscriber.persisted?
    
    if @email_subscriber.save 
      EmailList.where(auto_subscribe: true). each do |list|
        EmailSubscription.find_or_create_by(email_subscriber_id: @email_subscriber.id, email_list_id: list.id)
      end
    end
    
    respond_to do |format|
      format.html do
        if params[:redirect].presence
          redirect_to params[:redirect]
        else
          redirect_back(fallback: root_path)
        end
      end
      format.js
    end
  
  end
  
  def one_click_remove
    @email_subscriber = EmailSubscriber.find_by(uuid: params[:uuid])
    @email_subscriber.update_attribute(:opted_out, true) unless @email_subscriber.nil?
  end
  
  
  def resubscribe
    @subscriber = EmailSubscriber.find_by(uuid: params[:uuid])
    unless @subscriber.nil?
      @subscriber.update_attribute(:opted_out, false)
      EmailSubscription.where(email_subscriber_id: @subscriber.id).delete_all 
      
      params[:email_list_id].each { |x| EmailSubscription.create(email_list_id: x, email_subscriber_id: @subscriber.id) }
    end
  end
  
  
  private
  
    def email_subscriber_params
      params.require(:email_subscriber).permit(:email)
    end  
  
end
