class AffiliatesController < ApplicationController

  layout "single_column"

  # GET /aff/<id>?dest=xxx
  def capture
    aff = AffiliateCampaign.find(params[:id])

    unless aff.nil?
      if cookies[:acid].blank? || cookies[:acid] != params[:id]
        sql = "UPDATE mktg_affiliate_campaigns SET raw_clicks=raw_clicks+1, unique_clicks=unique_clicks+1 WHERE id=#{params[:id]}"
        cookies[:acid] = params[:id]
      else
        sql = "UPDATE mktg_affiliate_campaigns SET raw_clicks=raw_clicks+1 WHERE id=#{params[:id]}"
      end
      ActiveRecord::Base.connection.execute(sql)
    end

    # pass on any utm_ tracking parameters to the redirect
    filtered_params = []
    params.each do |k, v|
      filtered_params << "#{k}=#{v}" if k.start_with?("utm_")
    end
    str = filtered_params.join("&")

    # destination specified in the URL
    unless params[:dest].blank?
      return redirect_to params[:dest] + "?" + str
    end

    # destination specified in the campaign
    if aff && !aff.destination_url.blank?
      redirect_to aff.destination_url + "?" + str
    else
      redirect_to root_path + "?" + str
    end
  end

  # GET /ref/<key>?dest=xxx
  def referral
    cookies[:ref_key] = {value: params[:key], expires: 30.days.from_now}
    sql = "UPDATE core_user SET referral_clicks=referral_clicks+1 WHERE referral_key='#{params[:key]}'"
    ActiveRecord::Base.connection.execute(sql)

    unless params[:dest].blank?
      redirect_to params[:dest]
    else
      redirect_to root_path
    end
  end

  # GET /fbref/<key>?ddid=xxx&dest=xxx
  def facebook_referral
  end


  def new
    @affiliate = Affiliate.new
  end

  def create
    @affiliate = Affiliate.new(affiliate_params)

    unless verify_recaptcha(:model => @affiliate, :message => "Oh! It's error with reCAPTCHA!")
      return render "new"
    end

    unless @affiliate.valid? @affiliate.valid_password?
      return render "new"
    end

    # check if email is already in database
    user = User.find_by(email: @affiliate.email, domain_id: Rails.configuration.domain_id)
    unless user.nil?
      @affiliate.errors.add(:email, "already exists in our system.")
      return render 'new'
    end

    @affiliate.slug = SecureRandom.uuid
    if @affiliate.save(validate: false)
      user = User.new({
                          name: @affiliate.name,
                          email: @affiliate.email,
                          domain_id: Rails.configuration.domain_id,
                          role_id: Role.find_by(default: true).id,
                          password_digest: BCrypt::Password.create(@affiliate.password),
                          referral_key: SecureRandom.hex(5),
                          affiliate_id: @affiliate.id,
                          status: :active
                      })

      AffiliateCampaign.create(
          affiliate_id: @affiliate.id,
          name: "First Campaign",
          destination_url: "/",
          start_date: DateTime.now,
          end_date: DateTime.now + 1.year
      )

      if user.save
        session[:user_id] = user.id
        user.record_login(request, 'web')
        UserMailer.welcome_email(user.id).deliver_later

        return redirect_to action: 'show', id: @affiliate.id
      end
    end

    render 'new'
  end

  def show
    @user = User.find(session[:user_id])
    @affiliate = Affiliate.find(params[:id]) #if @user.affiliate_id == params[:id]
  end

  private

  def affiliate_params
    params.require(:affiliate).permit!
  end

end
