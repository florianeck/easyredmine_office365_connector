module EasyredmineOfficeConnector

  CONFIG_FILE_PATH         = File.expand_path("../../config/easyredmine_office365_connector.yml", __FILE__)

  cattr_reader :yaml_config
  class << self
    def config_from_yaml
      return self.yaml_config if self.yaml_config.present?

      if File.exists?(CONFIG_FILE_PATH)
        @@yaml_config = YAML::load(File.open(CONFIG_FILE_PATH).read)
      else
        raise LoadError, "Cant find config file under #{CONFIG_FILE_PATH}"
      end
    end

    def scope
      'Contacts.ReadWrite offline_access'
    end

    def client_id
      config_from_yaml['client_id']
    end

    def client_secret
      config_from_yaml['client_secret']
    end

    def contact_folder_name
      config_from_yaml['contact_folder_name']
    end

    def redirect_url
      Rails.application.routes.url_helpers.o365_callback_url(host: config_from_yaml['redirect_host'])
    end

    # Contact custom fields mapping
    [:mobile, :title, :job_title, :country, :website, :department].each do |cf_name|
      define_method "#{cf_name}_custom_field" do
        if cf_id = config_from_yaml.dig('custom_field_ids', cf_name.to_s)
          instance_variable_set("@_#{cf_name}_custom_field", CustomField.find(cf_id))
        end
      end

      define_method "#{cf_name}_custom_field_id" do
        config_from_yaml.dig('custom_field_ids', cf_name.to_s)
      end
    end

  end

end

require "easyredmine_office365_connector/base"
require "easyredmine_office365_connector/office365_sync_service"
require "easyredmine_office365_connector/hooks"
require "easyredmine_office365_connector/user_extension"
require "easyredmine_office365_connector/easy_contact_extension"

Rails.application.config.after_initialize do
  User.send :include, EasyredmineOffice365Connector::UserExtension
  EasyContact.send :include, EasyredmineOffice365Connector::EasyContactExtension
end
