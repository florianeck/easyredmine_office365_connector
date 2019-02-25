namespace :o365 do

  desc "Update Contacts on O365 Server"
  task :sync_contacts => :environment do
    Office365SyncPipeline.unsynced.each do |p|
      EasyredmineOfficeConnector::Office365SyncService.new(p).sync
    end
  end

end