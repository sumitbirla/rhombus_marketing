class Admin::Marketing::EmailListsController < Admin::BaseController

  def index
    authorize EmailList.new
    @email_lists = EmailList.order(:name)

    if @email_lists.length > 0
      sql = <<-EOF
        select 
      	  e.id,
      	  (select count(*) from mktg_email_subscriptions s where s.email_list_id = e.id),
      	  (select count(*) from mktg_email_blasts b where b.email_list_id = e.id and b.test = 0 and dispatched = 1),
          (select max(dispatch_time) from mktg_email_blasts b where b.email_list_id = e.id and b.test = 0 and dispatched = 1)
        from mktg_email_lists e
        where e.id in (#{@email_lists.map(&:id).join(",")});
      EOF

      @counts = []
      ActiveRecord::Base.connection.execute(sql).each { |row| @counts << row }
    end

    respond_to do |format|
      format.html { @email_lists = @email_lists.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data EmailList.to_csv(@email_lists) }
    end
  end

  def new
    @email_list = authorize EmailList.new(name: 'New email list')
    render 'edit'
  end

  def create
    @email_list = authorize EmailList.new(email_list_params)

    if @email_list.save
      flash[:success] = 'Email List was successfully created.'
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def show
    @email_list = authorize EmailList.find(params[:id])
  end

  def edit
    @email_list = authorize EmailList.find(params[:id])
  end

  def update
    @email_list = authorize EmailList.find(params[:id])

    if @email_list.update(email_list_params)
      flash[:success] = 'Email List was successfully updated.'
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @email_list = authorize EmailList.find(params[:id])
    @email_list.destroy

    flash[:success] = 'Email List has been deleted.'
    redirect_to action: 'index'
  end


  private

  def email_list_params
    params.require(:email_list).permit!
  end

end
