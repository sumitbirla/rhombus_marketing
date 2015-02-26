# == Schema Information
#
# Table name: email_lists
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  auto_subscribe :boolean          not null
#  user_managable :boolean          not null
#  description    :text
#  created_at     :datetime
#  updated_at     :datetime
#

class EmailList < ActiveRecord::Base
  self.table_name = 'mktg_email_lists'
  
  has_many :email_blasts
  has_many :email_subscriptions, dependent: :destroy
  has_many :email_subscribers, through: :email_subscriptions
  
  validates_presence_of :name
  
  def to_s
    name
  end
end
