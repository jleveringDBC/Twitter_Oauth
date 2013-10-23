get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  @user = User.find_or_create_by_oauth_token_and_oauth_secret_and_username(@access_token.params[:oauth_token], @access_token.params[:oauth_token_secret], @access_token.params[:screen_name])

  session[:user_id] = @user.id


  # at this point in the code is where you'll need to create your user account and store the access token

  erb :index

end


post '/status/:job_id' do
  if request.xhr?
    is_done = job_is_complete(params[:job_id])
    return is_done.to_s
  else
    redirect '/'
  end
end

post '/sendtweet' do
  @user = User.find(session[:user_id])
  @user.tweet(params[:theTweet], params[:theTime].to_i)
end
