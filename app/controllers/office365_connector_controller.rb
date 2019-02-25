class Office365ConnectorController < ApplicationController

  before_filter :require_login

  def auth
    session[:office365_auth_redirect] = params[:from]
    redirect_to office365_auth.auth_redirect_url
  end

  def unauth
    User.current.update_attributes(office365_oauth_token: nil)
    redirect_to :back
  end

  def callback
    if params[:code]
      response_for_token = office365_auth.post_token_request(params[:code])
      if response_for_token.code == '200'
        data = JSON.parse(response_for_token.body)
        user = User.current
        binding.pry
        user.update_attributes(
          office365_oauth_token: data['access_token'],
          office365_refresh_token: data['refresh_token']
        )
      else
        flash[:error] = "Office365 Auth Failed"
      end

      redirect_to session[:office365_auth_redirect] || my_path
    end
  end

  private

  def office365_auth
    @_office365_auth ||= EasyredmineOfficeConnector::Auth.new(
      EasyredmineOfficeConnector.client_id,
      EasyredmineOfficeConnector.client_secret,
      EasyredmineOfficeConnector.redirect_url,
      EasyredmineOfficeConnector.scope
    )
  end

end