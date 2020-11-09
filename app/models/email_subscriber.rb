# == Schema Information
#
# Table name: mktg_email_subscribers
#
#  id                    :integer          not null, primary key
#  uuid                  :string(255)      not null
#  email                 :string(255)      not null
#  name                  :string(255)
#  ip_address            :string(255)      default("")
#  affiliate_campaign_id :integer
#  referred_by           :integer
#  bounces               :integer          default("0")
#  reported_spam         :boolean          default("0")
#  opted_out             :boolean          default("0")
#  data1                 :string(255)
#  data2                 :string(255)
#  last_seen             :datetime
#  last_error            :text(65535)
#  created_at            :datetime
#  updated_at            :datetime
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
