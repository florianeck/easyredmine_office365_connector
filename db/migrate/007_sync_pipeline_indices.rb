class SyncPipelineIndices < ActiveRecord::Migration

  def change
    add_index :office365_sync_pipeline, :entry_type
    add_index :office365_sync_pipeline, :entry_id
    add_index :office365_sync_pipeline, :status
  end

end