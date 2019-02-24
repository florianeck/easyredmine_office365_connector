module EasyredmineOffice365Connector
  module UserExtension

    extend ActiveSupport::Concern

    included do
      safe_attributes :office365_oauth_token, :office365_project_ids_enabled
      serialize :office365_project_ids_enabled, Array
    end

    def office365_active?
      office365_oauth_token.present?
    end

    def office365_projects_enabled
      self.projects.where(id: office365_project_ids_enabled)
    end

    def o365_api
      @_o365_api ||= EasyredmineOfficeConnector::Api.new(self.office365_oauth_token, self)
    end

  end
end