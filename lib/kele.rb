require "httparty"
require "json"

class Kele
  include HTTParty
  base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
    if @user_token == nil
      "Invalid Credentials"
    else
      "Welcome"
    end
    @user_token = response["auth_token"]
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: {"authorization" => @user_token })
    user_data = JSON.parse(response.body)
  end
end
