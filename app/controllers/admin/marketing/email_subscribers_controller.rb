class Admin::Marketing::EmailSubscribersController < Admin::BaseController
  
  def index
    @email_subscribers = EmailSubscriber.page(params[:page]).order('created_at DESC')
    @email_subscribers = @email_subscribers.where("email LIKE '%#{params[:q]}%'") unless params[:q].nil?
  end

  def new
    @email_subscriber = EmailSubscriber.new email: 'New email', bounces: 0
    render 'edit'
  end

  def create
    @email_subscriber = EmailSubscriber.new(email_subscriber_params)
    @email_subscriber.ip_address = request.remote_ip

    if @email_subscriber.save
      
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
      
      redirect_to action: 'index', notice: 'Email Subscriber was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @email_subscriber = EmailSubscriber.find(params[:id])
  end

  def edit
    @email_subscriber = EmailSubscriber.find(params[:id])
  end

  def update
    @email_subscriber = EmailSubscriber.find(params[:id])
    
    if @email_subscriber.update(email_subscriber_params)
      
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
      
      redirect_to action: 'index', notice: 'Email Subscriber was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @email_subscriber = EmailSubscriber.find(params[:id])
    @email_subscriber.destroy
    redirect_to action: 'index', notice: 'Email Subscriber has been deleted.'
  end
  
  
  private
  
    def email_subscriber_params
      params.require(:email_subscriber).permit(:email, :name, :bounces, :reported_spam, :opted_out, :data1, :data2)
    end
  
end