class Admin::Marketing::EmailListsController < Admin::BaseController
  
  def index
    @email_lists = EmailList.page(params[:page]).order('name')
  end

  def new
    @email_list = EmailList.new name: 'New email list'
    render 'edit'
  end

  def create
    @email_list = EmailList.new(email_list_params)
    
    if @email_list.save
      redirect_to action: 'index', notice: 'Email List was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @email_list = EmailList.find(params[:id])
  end

  def edit
    @email_list = EmailList.find(params[:id])
  end

  def update
    @email_list = EmailList.find(params[:id])
    
    if @email_list.update(email_list_params)
      redirect_to action: 'index', notice: 'Email List was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @email_list = EmailList.find(params[:id])
    @email_list.destroy
    redirect_to action: 'index', notice: 'Email List has been deleted.'
  end
  
  
  private
  
    def email_list_params
      params.require(:email_list).permit(:name, :auto_subscribe, :user_managable, :description)
    end
  
end
