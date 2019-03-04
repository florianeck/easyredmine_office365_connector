module EasyredmineOfficeConnector
  class Office365SyncService

    attr_reader :pipeline_entry, :api_action

    def initialize(pipeline_entry)
      @pipeline_entry = pipeline_entry
      @users = Array.wrap(@pipeline_entry.user || @pipeline_entry.get_users_for_sync)
      @api_action = case @pipeline_entry.entry.class.name
      when "EasyContact"
        :create_or_update_contact
      end
    end

    def sync
      @users.each do |user|
        user_pipeline_entry = Office365SyncPipeline.new(@pipeline_entry.attributes.merge(user_id: user.id, id: nil))
        begin
          if user.o365_api.send(api_action, pipeline_entry.entry)
            user_pipeline_entry.status = 'ok'
            user_pipeline_entry.synced_at = Time.now
          else
            user_pipeline_entry.status = 'fail'
          end
        rescue Exception => e
          user_pipeline_entry.status = 'fail'
        end
        user_pipeline_entry.save
      end
      @pipeline_entry.destroy
    end

  end
end