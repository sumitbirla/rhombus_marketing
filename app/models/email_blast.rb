# == Schema Information
#
# Table name: mktg_email_blasts
#
#  id               :integer          not null, primary key
#  approved         :boolean          default(FALSE), not null
#  body             :text(65535)
#  bounces          :integer          default(0), not null
#  clicks           :integer          default(0), not null
#  dispatch_time    :datetime
#  dispatched       :boolean          default(FALSE), not null
#  from_email       :string(255)      not null
#  from_name        :string(255)      not null
#  html             :boolean          not null
#  html_body_url    :string(255)
#  last_error       :string(255)
#  opens            :integer          default(0), not null
#  sales            :integer          default(0), not null
#  scheduled_time   :datetime         not null
#  sent             :integer          default(0), not null
#  subject          :string(255)      not null
#  test             :boolean          default(FALSE), not null
#  text_body_url    :string(255)
#  title            :string(255)      not null
#  uuid             :string(255)      not null
#  created_at       :datetime
#  updated_at       :datetime
#  email_list_id    :integer          not null
#  voucher_group_id :integer
#
# Indexes
#
#  index_email_blasts_on_email_list_id     (email_list_id)
#  index_email_blasts_on_voucher_group_id  (voucher_group_id)
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
