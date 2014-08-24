module MarketingCache

  def self.affiliate_campaign(id)
    Rails.cache.fetch("affiliate-campaign:#{id}") do 
      AffiliateCampaign.find_by(id)
    end
  end

end