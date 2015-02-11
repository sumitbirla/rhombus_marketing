class AddUuidToEmailSubscribers < ActiveRecord::Migration
  def change
    add_column :mktg_email_subscribers, :uuid, :string, null: false
  end
end
