class EmailSubscribersController < ApplicationController

  def create  
    res = true
    @email_subscriber = EmailSubscriber.find_by(email: email_subscriber_params[:email])
    
    if @email_subscriber.nil?
      @email_subscriber = EmailSubscriber.new(email_subscriber_params)
      @email_subscriber.ip_address = request.remote_ip
      res = @email_subscriber.save 
    end
    
    if res 
      EmailList.where(auto_subscribe: true). each do |list|
        unless EmailSubscription.exists?(email_subscriber_id: @email_subscriber.id, email_list_id: list.id)
          EmailSubscription.create(email_subscriber_id: @email_subscriber.id, email_list_id: list.id)
        end
      end
    end
    
  end
  
  def one_click_remove
    @subscriber = EmailSubscriber.find_by(uuid: params[:uuid])
    @subscriber.update_attribute(:opted_out, true) unless @subscriber.nil?
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
