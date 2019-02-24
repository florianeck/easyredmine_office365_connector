module EasyredmineOfficeConnector
  class Auth

    AUTH_URL  = "https://login.microsoftonline.com/common/oauth2/v2.0/authorize"
    TOKEN_URL = "https://login.microsoftonline.com/common/oauth2/v2.0/token"

    attr_reader :client_id, :client_secret, :scope, :redirect_url

    def initialize(client_id, client_secret, redirect_url = "http://localhost:3000/o365/callback", scope = 'all')
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

    def token_request_params(code)
      {
        client_id: @client_id,
        client_secret: @client_secret,
        redirect_uri: @redirect_url,
        code: code,
        grant_type: 'authorization_code'
      }
    end

    def post_token_request(code)
      response = Net::HTTP.post_form(
        URI(TOKEN_URL),
        token_request_params(code).stringify_keys
      )
      return response
    end

  end

  class Api
    require "rest-client"

    BASE_URL = "https://api.sipgate.com/v1"

    attr_reader :access_token

    def initialize(access_token)
      @access_token = access_token
    end

    #== Authorization

    def authorization_userinfo
      get("/authorization/userinfo")
    end

    #== devices
    def devices_for_user(userid)
      get "/#{userid}/devices"
    end

    #== history
    def history_for_user(userid, params = {})
      get "/#{userid}/history", params
    end

    def history_delete(userId, entryId)
      delete "/#{userId}/history/#{entryId}"
    end

    #== numbers
    def numbers_for_user(userid)
      get("/#{userid}/numbers")
    end

    #== sessions
    def calls(deviceid, callee)
      post("/sessions/calls", {
        "caller": deviceid,
        "callee": callee
      })
    end

    #== Users
    def users
      get("/users")
    end

    private

    def get(path, params = {})
      JSON.parse(RestClient::Request.execute(method: :get, url: url(path), headers: headers.merge(params: params), verify_ssl: false))
    end

    def post(path, params)
      RestClient.post(url(path), params.to_json, headers) do |response|
        response
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