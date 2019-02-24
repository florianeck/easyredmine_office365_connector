get "/o365/auth"       => "office365_connector#auth",       as: :o365_auth
get "/o365/unauth"     => "office365_connector#unauth",     as: :o365_unauth
get "/o365/callback"   => "office365_connector#callback",   as: :o365_callback
get "/o365/data"       => "office365_connector#data",       as: :o365_data

