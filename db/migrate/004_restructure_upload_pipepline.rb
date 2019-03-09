class RestructureUploadPipepline < ActiveRecord::Migration

  def change
    remove_column :office365_sync_pipeline, :synced_for_user_ids if column_exists?(:office365_sync_pipeline, :synced_for_user_ids)
    remove_column :office365_sync_pipeline, :sync_failed_for_user_ids if column_exists?(:office365_sync_pipeline, :sync_failed_for_user_ids)
    add_column    :office365_sync_pipeline, :status, :string, default: 'pending' unless column_exists?(:office365_sync_pipeline, :status)
    add_column    :office365_sync_pipeline, :user_id, :integer
  end

end