class CreateO365SyncPipeline < ActiveRecord::Migration

  def change
    create_table :office365_sync_pipeline, :force => true do |t|
      t.string :entry_type
      t.string :entry_id
      t.datetime :synced_at
      t.text :synced_for_user_ids
      t.text :sync_failed_for_user_ids
      t.timestamps
    end

    add_index :office365_sync_pipeline, :entry_type
    add_index :office365_sync_pipeline, :entry_id

    create_table :office365_easy_contacts_user_mappings, :force => true do |t|
      t.integer :user_id
      t.integer :easy_contact_id
      t.string :office365_contact_id
    end

    add_index :office365_easy_contacts_user_mappings, :user_id
    add_index :office365_easy_contacts_user_mappings, :easy_contact_id
  end

end