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
      # Adding users that added contact as favorite
      users_for_sync << self.entry.users.where(office365_always_sync_favorite: true)

      # Adding users that want to sync all contacts
      users_for_sync << User.where(office365_contact_sync_mode: 'all_contacts')

      self.entry.projects.each do |project|
        users_for_sync << project.users.select do |u|
          # adding users that only want to sync selected projects
          if u.office365_contact_sync_mode == 'selected_projects'
            u.office365_projects_enabled.include?(project)
          # adding users that want to sync all contacts from projects
          elsif u.office365_contact_sync_mode == 'all_projects'
            true
          end
        end
      end
    end

    users_for_sync.flatten.uniq.select(&:office365_active?)
  end

  def cancel_if_pending_entry_exists!
    if self.status == 'pending' && self.class.find_by(entry_id: self.entry.id, entry_type: self.entry.class.name, status: 'pending').present?
      return false
    end
  end

end