class AffiliatesController < ApplicationController
  
  # GET /aff/<id>?dest=xxx
  def capture
    aff = AffiliateCampaign.find(params[:id])
    
    unless aff.nil?
      if cookies[:acid].blank? || cookies[:acid] != params[:id]
        sql = "UPDATE mktg_affiliate_campaigns SET raw_clicks=raw_clicks+1 AND unique_clicks=unique_clicks+1 WHERE id=#{params[:id]}"
        cookies[:acid] = params[:id]
      else
        sql = "UPDATE mktg_affiliate_campaigns SET raw_clicks=raw_clicks+1 WHERE id=#{params[:id]}"
      end
      ActiveRecord::Base.connection.execute(sql)
    end
    
    return redirect_to params[:dest] unless params[:dest].blank?
    
    if aff && !aff.destination_url.blank?
      redirect_to aff.destination_url
    else
      redirect_to root_path
    end
  end
  
  # GET /ref/<key>?dest=xxx
  def referral
    cookies[:ref_key] = { value: params[:key], expires: 30.days.from_now }
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
end
