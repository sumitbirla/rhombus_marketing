class Account::AffiliateController < Account::BaseController

  def show
    @affiliate = Affiliate.find(current_user.affiliate_id)
  end

  def edit
    @affiliate = Affiliate.find(current_user.affiliate_id)
  end

  def update
    @affiliate = Affiliate.find(current_user.affiliate_id)

    if @affiliate.update(affiliate_params)
      flash[:success] = 'Your affiliate info successfully updated.'
      redirect_to action: 'show'
    else
      render 'edit'
    end
  end


  private

  def affiliate_params
    params.require(:affiliate).permit(:name, :street1, :street2, :city, :state, :zip, :country,
                                      :contact_person, :email, :phone, :fax, :website, :tax_id)
  end

end
