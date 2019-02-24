module EasyredmineOffice365Connector
  module EasyContactExtension

    extend ActiveSupport::Concern

    included do
      after_save :add_to_o365_sync_pipeline
    end

    def to_o365_hash
      O365ContactMapper.new(self).to_hash
    end

    def o365_id_for_user(user)
      o365_user_mapping(user).office365_contact_id
    end

    def set_o365_id_for_user(user, o365_id)
      if o365_id_for_user(user).nil?
        o365_user_mapping(user).update_attributes(office365_contact_id: o365_id)
      end
    end

    def o365_user_mapping(user)
      @_o365_user_mapping ||= Office365EasyContactsUserMapping.find_or_create_by(user_id: user.id, easy_contact_id: self.id)
    end

    def add_to_o365_sync_pipeline
      Office365SyncPipeline.create(entry: self)
    end

  end
end