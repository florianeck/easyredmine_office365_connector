class AddOffice365DataToUser < ActiveRecord::Migration

  def change
    add_column :users, :office365_oauth_token, :text
    add_column :users, :office365_project_ids_enabled, :text
  end

end