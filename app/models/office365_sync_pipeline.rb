class Office365SyncPipeline < ActiveRecord::Base

  scope :unsynced, -> { where(synced_at: nil) }

  self.table_name = 'office365_sync_pipeline'

  belongs_to :entry, :class_name => "Entry", :polymorphic => true
  belongs_to :user

  validates_presence_of :entry_type, :entry_id

  before_save :cancel_if_pending_entry_exists!


  def get_users_for_sync
    users_for_sync = []
    case self.entry.class.name
    when "EasyContact"
      users_for_sync << self.entry.author

      unless self.entry.private?
        self.entry.projects.each do |project|
          users_for_sync << project.users.select {|u| u.office365_projects_enabled.include?(project) }
        end
      end
    end

    users_for_sync.flatten.uniq
  end

  def cancel_if_pending_entry_exists!
    if self.status == 'pending' && self.class.find_by(entry_id: self.entry.id, entry_type: self.entry.class.name, status: 'pending').present?
      return false
    end
  end

end