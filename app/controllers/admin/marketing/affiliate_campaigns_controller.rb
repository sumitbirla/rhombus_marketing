class Admin::Marketing::AffiliateCampaignsController < Admin::BaseController
  
  def index
    @affiliate_campaigns = AffiliateCampaign.page(params[:page]).order('start_date DESC')
  end

  def new
    @affiliate_campaign = AffiliateCampaign.new name: 'New campaign', raw_clicks: 0, unique_clicks: 0, signups: 0, orders: 0, destination_url: '/', signup_commission: 0.0, sale_commission: 10.0
    render 'edit'
  end

  def create
    @affiliate_campaign = AffiliateCampaign.new(affiliate_campaign_params)
    
    if @affiliate_campaign.save
      redirect_to action: 'index', notice: 'Affiliate Campaign was successfully created.'
    else
      render 'edit'
    end
  end

  def show
    @affiliate_campaign = AffiliateCampaign.find(params[:id])
  end

  def edit
    @affiliate_campaign = AffiliateCampaign.find(params[:id])
  end

  def update
    @affiliate_campaign = AffiliateCampaign.find(params[:id])
    
    if @affiliate_campaign.update(affiliate_campaign_params)
      Rails.cache.delete @affiliate_campaign
      redirect_to action: 'index', notice: 'Affiliate Campaign was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @affiliate_campaign = AffiliateCampaign.find(params[:id])
    Rails.cache.delete @affiliate_campaign
    @affiliate_campaign.destroy
    
    redirect_to action: 'index', notice: 'Affiliate Campaign has been deleted.'
  end
  
  
  private
  
    def affiliate_campaign_params
      params.require(:affiliate_campaign).permit(:affiliate_id, :name, :destination_url, :signup_commission, :sale_commission, 
      :start_date, :end_date, :record_history, :raw_clicks, :unique_clicks, :signups, :orders)
    end
  
end
