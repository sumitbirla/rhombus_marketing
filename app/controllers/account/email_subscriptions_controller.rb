class Account::EmailSubscriptionsController < Account::BaseController

  def index
    # find subscriber record for this user
    @email_subscriber = EmailSubscriber.find_by(email: current_user.email)

    unless @email_subscriber
      @email_subscriber = EmailSubscriber.create email: current_user.email, name: current_user.name, ip_address: request.remote_ip
    end

    @email_lists = EmailList.where(user_managable: true)
  end


  def create
    @email_subscriber = EmailSubscriber.find_by(email: current_user.email)

    EmailList.all.each do |list|

      subscription = @email_subscriber.subscriptions.find { |s| s.email_list_id == list.id }
      list_id = "list-#{list.id}"

      # DELETE
      if params[list_id].blank?
        subscription.destroy if subscription
        next
      end

      #ADD
      unless subscription
        subscription = EmailSubscription.new email_subscriber_id: @email_subscriber.id, email_list_id: list.id
        subscription.save
      end
    end

    respond_to do |format|
      format.html do
        flash[:notice] =  'Email subscriptions were successfully updated.'
        redirect_to :back
      end
      format.js { render :layout => false }
    end
    
  end

end
