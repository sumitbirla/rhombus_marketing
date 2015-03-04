class AddLastSeenToMktgEmailSubscribers < ActiveRecord::Migration
  def change
    add_column :mktg_email_subscribers, :last_seen, :datetime
    add_column :mktg_email_subscribers, :last_error, :text
  end
end
