# == Schema Information
#
# Table name: mktg_email_subscriptions
#
#  id                  :integer          not null, primary key
#  email_subscriber_id :integer          not null
#  email_list_id       :integer          not null
#

class EmailSubscription < ActiveRecord::Base
  self.table_name = 'mktg_email_subscriptions'

  belongs_to :email_subscriber
  belongs_to :email_list

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
