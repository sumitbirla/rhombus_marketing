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
  validates_presence_of :email, :uuid
  validates_uniqueness_of :email, message: " is already subscribed."
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  def inactive?
    opted_out || reported_spam || bounces > 2
  end
  
  def self.to_csv
    CSV.generate do |csv|
      cols = column_names - []
      csv << cols
      all.each do |product|
        csv << product.attributes.values_at(*cols)
      end
    end
  end
  
end
