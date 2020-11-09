# == Schema Information
#
# Table name: mktg_email_blasts
#
#  id               :integer          not null, primary key
#  scheduled_time   :datetime         not null
#  email_list_id    :integer          not null
#  test             :boolean          default("0"), not null
#  sent             :integer          default("0"), not null
#  opens            :integer          default("0"), not null
#  bounces          :integer          default("0"), not null
#  clicks           :integer          default("0"), not null
#  sales            :integer          default("0"), not null
#  uuid             :string(255)      not null
#  title            :string(255)      not null
#  from_name        :string(255)      not null
#  from_email       :string(255)      not null
#  subject          :string(255)      not null
#  body             :text(65535)
#  voucher_group_id :integer
#  approved         :boolean          default("0"), not null
#  dispatched       :boolean          default("0"), not null
#  dispatch_time    :datetime
#  html             :boolean          not null
#  html_body_url    :string(255)
#  text_body_url    :string(255)
#  last_error       :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class EmailBlast < ActiveRecord::Base
  include Exportable
  self.table_name = 'mktg_email_blasts'

  belongs_to :email_list
  belongs_to :voucher_group

  validates_presence_of :title, :email_list_id, :from_name, :from_email, :subject, :scheduled_time

  # PUNDIT
  def self.policy_class
    ApplicationPolicy
  end
end
