class EmailBlastsController < ApplicationController

  # all links in email get redirected from here
  def redirect
    ActiveRecord::Base.connection.execute("UPDATE mktg_email_blasts SET clicks=clicks+1 WHERE uuid='#{params[:uuid]}'")
    cookies[:ebuuid] = {value: params[:uuid], expires: 1.day.from_now}

    if params[:dest].blank?
      redirect_to root_url
    else
      redirect_to params[:dest]
    end
  end

  # when an email is viewed, there is an embedded transarent image
  # <img src="<%= web_url %>/image/pixel?guid=[GUID]" alt=""/>
  def pixel
    if params[:uuid]
      ActiveRecord::Base.connection.execute("UPDATE mktg_email_blasts SET opens=opens+1 WHERE uuid='#{params[:uuid]}'")
    elsif params[:acid]
      ActiveRecord::Base.connection.execute("UPDATE mktg_affiliate_campaigns SET opens=opens+1 WHERE id=#{params[:acid]}")
    end
    send_file Rails.root.join('public', 'pixel.gif')
  end
end
