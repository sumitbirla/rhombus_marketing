class Admin::Marketing::AffiliateCampaignsController < Admin::BaseController
  
  def index
    @affiliate_campaigns = AffiliateCampaign.includes(:affiliate).page(params[:page]).order(start_date: :desc)
  end

  def new
    @affiliate_campaign = AffiliateCampaign.new name: 'New campaign', raw_clicks: 0, unique_clicks: 0, signups: 0, orders: 0, destination_url: '/', signup_commission: 0.0, sale_commission: 10.0
    render 'edit'
  end

  def create
    @affiliate_campaign = AffiliateCampaign.new(affiliate_campaign_params)
    
    if @affiliate_campaign.save
      flash[:success] = 'Affiliate Campaign was successfully created.'
      redirect_to action: 'index'
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
      
      flash[:success] = 'Affiliate Campaign was successfully updated.'
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  def destroy
    @affiliate_campaign = AffiliateCampaign.find(params[:id])
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
