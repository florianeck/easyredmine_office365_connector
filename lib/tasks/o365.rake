namespace :o365 do

  desc "Update Contacts on O365 Server"
  task :sync_contacts => :environment do
    lockfile = "#{Rails.root}/tmp/osync.lock"
    unless File.exists?(lockfile)

      File.open(lockfile, "wb") {|f| f.puts Time.now.to_i }

      if ENV['FULL_SYNC'] == 'true'
        puts "RUNNING in Full Sync Mode!"
        EasyContact.all.each(&:add_to_o365_sync_pipeline)
      end

      begin
        Parallel.each(Office365SyncPipeline.unsynced, in_threads: 4) do |p|
          EasyredmineOfficeConnector::Office365SyncService.new(p).sync
        end

        EasyredmineOfficeConnector::Office365SyncService.cleanup_deleted_entries
      ensure
        FileUtils.rm(lockfile)
      end
    end
  end

  desc "refresh all tokens for users with refresh token"
  task :refresh_tokens => :environment do
    User.where.not(office365_refresh_token: nil).each do |user|
      user.o365_api.refresh_token!
    end
  end

end