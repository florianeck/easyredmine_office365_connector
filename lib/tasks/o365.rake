namespace :o365 do

  desc "Update Contacts on O365 Server"
  task :sync_contacts => :environment do
    Office365SyncPipeline.unsynced.each do |p|
      EasyredmineOfficeConnector::Office365SyncService.new(p).sync
    end
  end

  desc "refresh all tokens for users with refresh token"
  task :refresh_tokens do
    User.where.not(office365_refresh_token: nil).each do |user|
      user.o365_api.refresh_token!
    end
  end

end