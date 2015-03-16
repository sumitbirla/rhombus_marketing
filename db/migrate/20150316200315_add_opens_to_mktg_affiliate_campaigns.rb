class AddOpensToMktgAffiliateCampaigns < ActiveRecord::Migration
  def change
    add_column :mktg_affiliate_campaigns, :opens, :integer, null: false, default: 0
  end
end
