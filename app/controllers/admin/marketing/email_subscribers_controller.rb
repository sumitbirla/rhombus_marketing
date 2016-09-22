class Admin::Marketing::EmailSubscribersController < Admin::BaseController
  
  def index
    @email_subscribers = EmailSubscriber.order(created_at: :desc)
    @email_subscribers = @email_subscribers.where(id: EmailSubscription.select("email_subscriber_id").where(email_list_id: params[:email_list_id])) unless params[:email_list_id].blank?
    @email_subscribers = @email_subscribers.where("email LIKE '%#{params[:q]}%'") unless params[:q].nil?
    
    respond_to do |format|
      format.html { @email_subscribers = @email_subscribers.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data EmailSubscriber.to_csv(@email_subscribers) }
    end
  end

  def new
    @email_subscriber = EmailSubscriber.new email: 'New email', bounces: 0
    render 'edit'
  end

  def create
    @email_subscriber = EmailSubscriber.new(email_subscriber_params)
    @email_subscriber.ip_address = request.remote_ip
    @email_subscriber.uuid = SecureRandom.uuid

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
      
      flash[:success] = 'Email Subscriber was successfully created.'
      redirect_to action: 'index'
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
      
      flash[:success] = 'Email Subscriber was successfully updated.'
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @email_subscriber = EmailSubscriber.find(params[:id])
    @email_subscriber.destroy
    
    flash[:success] = 'Email Subscriber has been deleted.'
    redirect_to action: 'index'
  end
  
  
  private
  
    def email_subscriber_params
      params.require(:email_subscriber).permit!
    end
  
end
