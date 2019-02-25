module EasyredmineOfficeConnector
  class Auth

    AUTH_URL  = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
    TOKEN_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/token"

    attr_reader :client_id, :client_secret, :scope, :redirect_url

    def initialize(client_id = EasyredmineOfficeConnector.client_id, client_secret = EasyredmineOfficeConnector.client_secret, redirect_url = EasyredmineOfficeConnector.redirect_url, scope = EasyredmineOfficeConnector.scope)
      @client_id       = client_id
      @client_secret   = client_secret
      @scope        = scope
      @redirect_url = redirect_url
    end

    # Auth Code part

    def auth_request_params
      {
        client_id: @client_id,
        redirect_uri: @redirect_url,
        scope: @scope,
        response_type: 'code'
      }
    end

    def auth_redirect_url
      url = URI(AUTH_URL)
      url.query = URI.encode_www_form(auth_request_params)
      return url.to_s
    end

    # Access Token Part

    def token_request_params(code, grant_type = 'authorization_code')
      {
        client_id: @client_id,
        client_secret: @client_secret,
        redirect_uri: @redirect_url,
        (grant_type == 'authorization_code' ? 'code' : 'refresh_token') => code,
        grant_type: grant_type
      }
    end

    def post_token_request(code, grant_type = 'authorization_code')
      response = Net::HTTP.post_form(
        URI(TOKEN_URL),
        token_request_params(code, grant_type).stringify_keys
      )
      return response
    end

  end

  class Api
    require "rest-client"

    BASE_URL = "https://graph.microsoft.com/v1.0"

    attr_reader :access_token, :user

    def initialize(access_token, user)
      @access_token = access_token
      @user = user
    end

    def refresh_token!
      response = EasyredmineOfficeConnector::Auth.new.post_token_request(user.office365_refresh_token, 'refresh_token')
      data = JSON.parse(response.body)
      @user.update_attributes(
        office365_oauth_token: data['access_token'],
        office365_refresh_token: data['refresh_token']
      )
    end

    def create_or_update_contact(easy_contact)
      # decide wether to update or create
      settings = if easy_contact.o365_id_for_user(@user).nil? # => create
        { url: "/me/contacts" , method: :post }
      else
        { url: "/me/contacts/#{easy_contact.o365_id_for_user(@user)}" , method: :patch }
      end

      self.send(settings[:method], settings[:url], easy_contact.to_o365_hash) do |response|
        puts response.body
        if settings[:method] == :post # => create
          begin
            if JSON.parse(response.body)['id']
              easy_contact.set_o365_id_for_user(@user, JSON.parse(response.body)['id'])
              return true
            else
              return false
            end
          rescue Exception => e
            # TODO: Add Custom Error Logger for Office
            binding.pry
          end
        else
          if response.inspect.include?('200')
            return true
          else
            binding.pry
          end
        end
      end

      @user.refresh_token!
    end


    private

    def get(path, params = {})
      JSON.parse(RestClient::Request.execute(method: :get, url: url(path), headers: headers.merge(params: params), verify_ssl: false))
    end

    def post(path, params)
      RestClient.post(url(path), params.to_json, headers) do |response|
        yield(response)
      end
    end

    def patch(path, params)
      RestClient.patch(url(path), params.to_json, headers) do |response|
        yield(response)
      end
    end

    def delete(path)
      RestClient.delete(url(path), headers)
    end

    def url(path)
      File.join(BASE_URL, path)
    end

    def headers
      {"authorization" => "bearer #{access_token}", "content-type" => "application/json", "accept" => "application/json"}
    end
  end
end