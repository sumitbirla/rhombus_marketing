# == Schema Information
#
# Table name: mktg_email_subscriptions
#
#  id                  :integer          not null, primary key
#  email_list_id       :integer          not null
#  email_subscriber_id :integer          not null
#
# Indexes
#
#  index_email_subscriptions_on_email_list_id        (email_list_id)
#  index_email_subscriptions_on_email_subscriber_id  (email_subscriber_id)
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
