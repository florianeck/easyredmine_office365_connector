module EasyredmineOffice365Connector
  module UserExtension

    extend ActiveSupport::Concern

    included do
      safe_attributes :office365_oauth_token, :office365_project_ids_enabled,
        :office365_contact_sync_mode, :office365_always_sync_favorite, :office365_sync_contact_types

      serialize :office365_project_ids_enabled, Array
      serialize :office365_sync_contact_types, Array

      def self.contact_sync_modes
        [
          :selected_projects,
          :all_projects,
          :all_contacts,
          :no_sync
        ]
      end

      after_save :setup_full_sync_if_settings_changed
    end

    def office365_active?
      office365_oauth_token.present?
    end

    def office365_projects_enabled
      office365_active? ? self.projects.where(id: office365_project_ids_enabled) : []
    end

    def o365_api
      EasyredmineOfficeConnector::Api.new(self.office365_oauth_token, self)
    end

    private

    def o365_contact_sync_settings_changed?
      office365_project_ids_enabled_changed? ||
      office365_contact_sync_mode_changed? ||
      office365_always_sync_favorite_changed? ||
      office365_sync_contact_types_changed?
    end

    def setup_full_sync_if_settings_changed
      if o365_contact_sync_settings_changed?
        EasyContact.all.each(&:add_to_o365_sync_pipeline)
      end
    end

  end
end