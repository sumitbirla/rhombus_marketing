# == Schema Information
#
# Table name: mktg_email_lists
#
#  id             :integer          not null, primary key
#  auto_subscribe :boolean          default(FALSE), not null
#  description    :text(65535)
#  name           :string(255)      not null
#  user_managable :boolean          default(FALSE), not null
#  created_at     :datetime
#  updated_at     :datetime
#

class EmailList < ActiveRecord::Base
  include Exportable
  self.table_name = 'mktg_email_lists'

  has_many :email_blasts
  has_many :email_subscriptions, dependent: :destroy
  has_many :email_subscribers, through: :email_subscriptions

  validates_presence_of :name

  def to_s
    name
  end

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
