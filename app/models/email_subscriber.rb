# == Schema Information
#
# Table name: mktg_email_subscribers
#
#  id                    :integer          not null, primary key
#  bounces               :integer          default(0)
#  data1                 :string(255)
#  data2                 :string(255)
#  email                 :string(255)      not null
#  ip_address            :string(255)      default("")
#  last_error            :text(65535)
#  last_seen             :datetime
#  name                  :string(255)
#  opted_out             :boolean          default(FALSE)
#  referred_by           :integer
#  reported_spam         :boolean          default(FALSE)
#  uuid                  :string(255)      not null
#  created_at            :datetime
#  updated_at            :datetime
#  affiliate_campaign_id :integer
#
# Indexes
#
#  index_email_subscribers_on_affiliate_campaign_id  (affiliate_campaign_id)
#

class EmailSubscriber < ActiveRecord::Base
  include Exportable
  self.table_name = 'mktg_email_subscribers'

  belongs_to :affiliate_campaign
  belongs_to :referrer, class_name: 'User', foreign_key: 'referred_by'
  has_many :subscriptions, class_name: 'EmailSubscription'
  validates_presence_of :email, :uuid
  validates_uniqueness_of :email, message: " is already subscribed."
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def inactive?
    opted_out || reported_spam || bounces > 2
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
