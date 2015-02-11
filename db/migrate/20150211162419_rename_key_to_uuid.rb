class RenameKeyToUuid < ActiveRecord::Migration
  def change
	rename_column :mktg_email_blasts, :key, :uuid
  end
end
