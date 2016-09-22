class Account::AffiliateCampaignsController < Account::BaseController
  def index
    @affiliate_campaigns = AffiliateCampaign.where(affiliate_id: current_user.affiliate_id)
                                            .paginate(page: params[:page], per_page: @per_page)
                                            .order(start_date: :desc)
  end
end
