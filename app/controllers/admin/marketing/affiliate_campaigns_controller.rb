class Admin::Marketing::AffiliateCampaignsController < Admin::BaseController
  
  def index
    authorize AffiliateCampaign.new
    @affiliate_campaigns = AffiliateCampaign.includes(:affiliate).order(start_date: :desc)
    
    respond_to do |format|
      format.html { @affiliate_campaigns = @affiliate_campaigns.paginate(page: params[:page], per_page: @per_page) }
      format.csv { send_data AffiliateCampaign.to_csv(@affiliate_campaigns) }
    end
  end

  def new
    @affiliate_campaign = authorize AffiliateCampaign.new(name: 'New campaign', raw_clicks: 0, unique_clicks: 0, signups: 0, orders: 0, destination_url: '/', signup_commission: 0.0, sale_commission: 10.0)
    render 'edit'
  end

  def create
    @affiliate_campaign = authorize AffiliateCampaign.new(affiliate_campaign_params)
    
    if @affiliate_campaign.save
      flash[:success] = 'Affiliate Campaign was successfully created.'
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def show
    @affiliate_campaign = authorize AffiliateCampaign.find(params[:id])
  end

  def edit
    @affiliate_campaign = authorize AffiliateCampaign.find(params[:id])
  end

  def update
    @affiliate_campaign = authorize AffiliateCampaign.find(params[:id])
    
    if @affiliate_campaign.update(affiliate_campaign_params)
      Rails.cache.delete @affiliate_campaign
      
      flash[:success] = 'Affiliate Campaign was successfully updated.'
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @affiliate_campaign = authorize AffiliateCampaign.find(params[:id])
    Rails.cache.delete @affiliate_campaign
    @affiliate_campaign.destroy
    
    flash[:success] = 'Affiliate Campaign has been deleted.'
    redirect_to action: 'index'
  end
  
  
  private
  
    def affiliate_campaign_params
      params.require(:affiliate_campaign).permit!
    end
  
end
