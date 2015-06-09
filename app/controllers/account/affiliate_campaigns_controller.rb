class Account::AffiliateCampaignsController < Account::BaseController
  def index
    @affiliate_campaigns = AffiliateCampaign.where(affiliate_id: current_user.affiliate_id)
                                            .page(params[:page])
                                            .order(start_date: :desc)
  end
end
