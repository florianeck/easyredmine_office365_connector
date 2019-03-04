class RestructureUploadPipepline < ActiveRecord::Migration

  def change
    remove_column :office365_sync_pipeline, :synced_for_user_ids
    remove_column :office365_sync_pipeline, :sync_failed_for_user_ids
    add_column    :office365_sync_pipeline, :status, default: 'pending'
    add_column    :office365_sync_pipeline, :user_id
  end

end