# == Schema Information
#
# Table name: mktg_affiliate_campaigns
#
#  id                :integer          not null, primary key
#  cookie_ttl        :integer          default(45), not null
#  destination_url   :string(255)      default(""), not null
#  end_date          :datetime         not null
#  name              :string(255)      not null
#  opens             :integer          default(0), not null
#  orders            :integer          default(0), not null
#  raw_clicks        :integer          default(0), not null
#  record_history    :boolean          default(FALSE), not null
#  sale_commission   :decimal(6, 2)    default(20.0), not null
#  signup_commission :decimal(6, 2)    default(0.0), not null
#  signups           :integer          default(0), not null
#  start_date        :datetime         not null
#  unique_clicks     :integer          default(0), not null
#  created_at        :datetime
#  updated_at        :datetime
#  affiliate_id      :integer          not null
#
# Indexes
#
#  index_affiliate_campaigns_on_affiliate_id  (affiliate_id)
#

class AffiliateCampaign < ActiveRecord::Base
  include Exportable
  self.table_name = 'mktg_affiliate_campaigns'

  belongs_to :affiliate
  validates_presence_of :affiliate_id, :name, :destination_url, :start_date, :end_date, :raw_clicks
  validates_presence_of :unique_clicks, :signups, :orders, :signup_commission, :sale_commission

  def to_s
    name
  end

  def cache_key
    "affiliate-campaign:#{id}"
  end

  def active?
    (start_date < DateTime.now) && (end_date > DateTime.now)
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end

end
