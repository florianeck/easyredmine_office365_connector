module EasyredmineOffice365Connector
  module UserExtension

    extend ActiveSupport::Concern

    included do
      safe_attributes :office365_oauth_token, :office365_project_id_settings
      serialize :office365_project_ids_enabled, Array
    end

    def office365_active?
      office365_oauth_token.present?
    end

    def office365_project_id_settings=(data)
      binding.pry
    end

    def office365_projects_enabled
      self.projects.where(id: office365_project_ids_enabled)
    end

  end
end