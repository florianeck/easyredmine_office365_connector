module EasyredmineOfficeConnector
  class Office365SyncService

    attr_reader :pipeline_entry, :api_action

    def initialize(pipeline_entry)
      @pipeline_entry = pipeline_entry
      @users = @pipeline_entry.get_users_for_sync

      @api_action = case @pipeline_entry.entry.class.name
      when "EasyContact"
        :create_or_update_contact
      end
    end

    def sync
      @users.each do |user|
        begin
          if user.o365_api.send(api_action, pipeline_entry.entry)
            @pipeline_entry.synced_for_user_ids << user.id
          else
            @pipeline_entry.sync_failed_for_user_ids << user.id
          end
        rescue Exception => e
          @pipeline_entry.sync_failed_for_user_ids << user.id
        end
      end
      @pipeline_entry.synced_at = Time.now
      @pipeline_entry.save
    end

  end
end