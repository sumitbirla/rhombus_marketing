class Admin::Marketing::EmailBlastsController < Admin::BaseController
  
  def index
    @email_blasts = EmailBlast.page(params[:page]).order('scheduled_time DESC')
  end

  def new
    @email_blast = EmailBlast.new title: 'New email blast'
    render 'edit'
  end

  def create
    @email_blast = EmailBlast.new(email_blast_params)
    @email_blast.uuid = SecureRandom.uuid
    
    if @email_blast.save
      redirect_to action: 'index', notice: 'Email Blast was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @email_blast = EmailBlast.find(params[:id])
  end

  def edit
    @email_blast = EmailBlast.find(params[:id])
  end

  def update
    @email_blast = EmailBlast.find(params[:id])
    
    if @email_blast.update(email_blast_params)
      redirect_to action: 'index', notice: 'Email Blast was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @email_blast = EmailBlast.find(params[:id])
    @email_blast.destroy
    redirect_to action: 'index', notice: 'Email Blast has been deleted.'
  end
  
  
  private
  
    def email_blast_params
      params.require(:email_blast).permit!
    end
  
end
