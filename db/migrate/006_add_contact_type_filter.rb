class AddContactTypeFilter < ActiveRecord::Migration

  def change
    add_column :users, :office365_sync_contact_types, :string
  end

end