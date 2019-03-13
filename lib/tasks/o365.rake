namespace :o365 do

  desc "Update Contacts on O365 Server"
  task :sync_contacts => :environment do

    if ENV['FULL_SYNC'] == 'true'
      puts "RUNNING in Full Sync Mode!"
      # EasyContact.all.each(&:add_to_o365_sync_pipeline)
    end

    Office365SyncPipeline.unsynced.each do |p|
      EasyredmineOfficeConnector::Office365SyncService.new(p).sync
    end
    EasyredmineOfficeConnector::Office365SyncService.cleanup_deleted_entries
  end

  desc "refresh all tokens for users with refresh token"
  task :refresh_tokens => :environment do
    User.where.not(office365_refresh_token: nil).each do |user|
      user.o365_api.refresh_token!
    end
  end

end