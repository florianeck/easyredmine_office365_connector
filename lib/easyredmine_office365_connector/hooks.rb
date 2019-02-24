module EasyredmineOffice365Connector
  class Hooks < Redmine::Hook::ViewListener

    render_on :view_my_account, :partial => 'office365_connector/user_settings'

  end
end