# == Schema Information
#
# Table name: email_blasts
#
#  id               :integer          not null, primary key
#  scheduled_time   :datetime         not null
#  email_list_id    :integer          not null
#  sent             :integer          not null
#  opens            :integer          not null
#  bounces          :integer          not null
#  clicks           :integer          not null
#  sales            :integer          not null
#  key              :string(255)      not null
#  title            :string(255)      not null
#  from_name        :string(255)      not null
#  from_email       :string(255)      not null
#  subject          :string(255)      not null
#  body             :text
#  voucher_group_id :integer
#  approved         :boolean          not null
#  test             :boolean          not null
#  dispatched       :boolean          not null
#  dispatch_time    :datetime
#  html             :boolean          not null
#  html_body_url    :string(255)
#  text_body_url    :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  last_error       :string(255)
#

class EmailBlast < ActiveRecord::Base
  self.table_name = 'mktg_email_blasts'
  
  belongs_to :email_list
  belongs_to :voucher_group
  
  validates_presence_of :title, :email_list_id, :from_name, :from_email, :subject
end
