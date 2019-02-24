class Office365SyncPipeline < ActiveRecord::Base

  scope :unsynced, -> { where(synced_at: nil) }

  serialize :synced_for_user_ids, Array
  serialize :sync_failed_for_user_ids, Array

  self.table_name = 'office365_sync_pipeline'

  belongs_to :entry, :class_name => "Entry", :polymorphic => true

  validates_presence_of :entry_type, :entry_id

  validates_uniqueness_of :entry_id, scope: [:entry_type, :synced_at]


  def get_users_for_sync
    users_for_sync = []
    case self.entry.class.name
    when "EasyContact"
      self.entry.projects.each do |project|
        users_for_sync << project.users.select {|u| u.office365_projects_enabled.include?(project) }
      end
    end

    users_for_sync.flatten.uniq
  end

end