class Admin::Marketing::EmailBlastsController < Admin::BaseController
  
  def index
    authorize EmailBlast.new
    @email_blasts = EmailBlast.where(test: false).includes(:email_list).order(scheduled_time: :desc)
    
    respond_to do |format|
      format.html { @email_blasts = @email_blasts.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data EmailBlast.to_csv(@email_blasts, skip_cols: ['body']) }
    end
  end

  def new
    @email_blast = authorize EmailBlast.new(title: 'New email blast')
    
    # copy from email and name from previous blast
    prev = EmailBlast.order(scheduled_time: :desc).first
    unless prev.nil?
      @email_blast.assign_attributes({
        email_list_id: prev.email_list_id,
        from_email: prev.from_email,
        from_name: prev.from_name
      })
    end
    
    unless params[:daily_deal_id].nil?
      dd = DailyDeal.find(params[:daily_deal_id])
      web_url = Cache.setting(:system, "Website URL")
      
      @email_blast.assign_attributes({
        title: dd.short_tag_line,
        scheduled_time: dd.start_time,
        subject: dd.title,
        html_body_url: web_url + deals_email_path(uuid: dd.uuid),
        text_body_url: web_url + deals_email_path(uuid: dd.uuid, format: :txt),
        approved: false
      })
    end
    
    render 'edit'
  end

  def create
    @email_blast = authorize EmailBlast.new(email_blast_params)
    @email_blast.uuid = SecureRandom.uuid
    
    if @email_blast.save
      flash[:success] = 'Email Blast was successfully created.'
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def show
    @email_blast = authorize EmailBlast.find(params[:id])
  end

  def edit
    @email_blast = authorize EmailBlast.find(params[:id])
  end

  def update
    @email_blast = authorize EmailBlast.find(params[:id])
    
    if @email_blast.update(email_blast_params)
      flash[:success] = 'Email Blast was successfully updated.'
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @email_blast = authorize EmailBlast.find(params[:id])
    @email_blast.destroy
    
    flash[:success] = 'Email Blast has been deleted.'
    redirect_to action: 'index'
  end
  
  def test
    eb = EmailBlast.find(params[:id])
    test_blast = eb.dup
    test_list = EmailList.find_by(name: "Test Email Recipients")
    
    if test_list.nil? || test_list.email_subscribers.count == 0
      flash[:error] = "There are no emails in the 'Test Email Recipients' list."
      return redirect_to :back
    end
    
    test_blast.assign_attributes({
      email_list_id: test_list.id,
      scheduled_time: DateTime.now,
      subject: "[TEST] " + eb.subject,
      approved: true,
      test: true,
      uuid: SecureRandom.uuid,
      sent: 0,
      opens: 0,
      bounces: 0,
      clicks: 0,
      sales: 0,
      dispatched: false,
      dispatch_time: nil,
      last_error: nil
    })
    test_blast.save
    
    flash[:success] = "Test email blast has been dispatched"
    redirect_to :back
  end
  
  
  private
  
    def email_blast_params
      params.require(:email_blast).permit!
    end
  
end
