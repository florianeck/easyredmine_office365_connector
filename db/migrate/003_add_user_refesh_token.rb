class AddUserRefeshToken < ActiveRecord::Migration

  def change
    add_column :users, :office365_refresh_token, :text
    remove_column :users, :office365_contact_folder_id, :text
  end

end