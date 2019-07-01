class SessionsController < ApplicationController
  skip_before_action :authenticate_user

  def create
    request = Faraday.post "https://github.com/login/oauth/access_token", {client_id: ENV["GITHUB_CLIENT"], client_secret: ENV["GITHUB_SECRET"]}

    response = JSON.parse(request.body)
    session[:token] = response["access_token"]

    token = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{session[:token]}", 'Accept' => 'application/json'}
    token_response = JSON.parse(token.body)
    session[:username] = token_response["login"]

    redirect_to '/'

  end
end
