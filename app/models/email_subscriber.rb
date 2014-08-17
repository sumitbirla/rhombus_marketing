# == Schema Information
#
# Table name: email_subscribers
#
#  id                    :integer          not null, primary key
#  email                 :string(255)      not null
#  name                  :string(255)
#  ip_address            :string(255)      not null
#  affiliate_campaign_id :integer
#  referred_by           :integer
#  bounces               :integer          default(0)
#  reported_spam         :boolean          default(FALSE)
#  opted_out             :boolean          default(FALSE)
#  created_at            :datetime
#  updated_at            :datetime
#  data1                 :string(255)
#  data2                 :string(255)
#

class EmailSubscriber < ActiveRecord::Base
  self.table_name = 'mktg_email_subscribers'
  
  belongs_to :affiliate_campaign
  belongs_to :referrer, class_name: 'User', foreign_key: 'referred_by'
  has_many :subscriptions, class_name: 'EmailSubscription'
  validates_presence_of :email
end
