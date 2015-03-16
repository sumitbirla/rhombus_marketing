module MarketingCache

  def self.affiliate_campaign(id)
    Rails.cache.fetch("affiliate-campaign:#{id}") do 
      AffiliateCampaign.find(id)
    end
  end

end