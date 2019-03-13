class AddContactSyncSettings < ActiveRecord::Migration

  def change
    add_column :users, :office365_contact_sync_mode, :string, default: :selected_projects
    add_column :users, :office365_always_sync_favorite, :boolean, default: true
  end

end