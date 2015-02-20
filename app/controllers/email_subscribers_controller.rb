class EmailSubscribersController < ApplicationController

  def create  
    res = true
    @email_subscriber = EmailSubscriber.find_by(email: params[:email])
    
    if @email_subscriber.nil?
      @email_subscriber = EmailSubscriber.new({
        email: params[:email],
        ip_address: request.remote_ip,
        uuid: SecureRandom.uuid
      })
      res = @email_subscriber.save 
    end
    
    if res 
      EmailList.where(auto_subscribe: true). each do |list|
        unless EmailSubscription.exists?(email_subscriber_id: @email_subscriber.id, email_list_id: list.id)
          EmailSubscription.create(email_subscriber_id: @email_subscriber.id, email_list_id: list.id)
        end
      end
    end
    
    flash[:info] = "You are now subscribed to the following email lists"
    render 'one_click_remove'
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
