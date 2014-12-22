set :protection, except: :session_hijacking
get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

post '/submit' do
  if params[:submit] == "signup"
        @user = User.new(username: params[:username], password: params[:password])
    @user.save
    @message = "Please sign in"
    session[:user_id] = @user.id
    redirect "/lobby"

  else
    # byebug
    if User.valid?(params[:username])
    user = User.where(username: params[:username]).first
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect "/lobby"
      else
        @message = "Wrong Password"
        erb :'users/new'
      end
    else
      @message = "No such user exists"
      erb :'users/new'
    end
  end

end
