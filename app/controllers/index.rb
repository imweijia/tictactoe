set :protection, except: :session_hijacking

get '/' do
  # Look in app/views/index.erb
  redirect '/lobby' if session[:user_id]
  erb :index
end
