set :protection, except: :session_hijacking
require 'byebug'

get '/lobby' do
  if Game.all.count != 0
    @hostgames = Game.where('player1_id = ? or player2_id = ?', session[:user_id], session[:user_id])

    @challengergames = Game.where('player1_id != ?', "#{session[:user_id]}")
  else
    @nogames = "No games yet."
  end
  erb :'games/lobby'
end

get '/game/play/:game_id' do
  if session[:user_id] == nil
    redirect '/'
  else
    @state = []
    @game_id = params[:game_id]
    @user_id = session[:user_id]
    @game = Game.find(@game_id)
    # byebug
    if @game.player2_id == nil && @game.player1_id != @user_id
      @game.update(player2_id: @user_id, status: 1)
    end
    if session[:user_id] == @game.player1_id
      @hover = "hover_x"
      @player = 1
    else
      @hover = "hover_o"
      @player = 2
    end
  @state = Game.get_state(@game)
  end

  erb :'games/game'
end

post '/game/play/:game_id' do
  user_id = session[:user_id]
  position = params[:position]
  game = Game.find(params[:game_id])
  move = game.moves.create(user_id: user_id, move: position)
  state = []

  if move.save

   state = Game.get_state(game)
  end
  state.to_json
end

get '/game/play/:game_id/poll' do
  user_id = session[:user_id]
  game = Game.find(params[:game_id])


  state = Game.get_state(game)
  state.to_json

end

get '/game/create' do
  game = Game.create(player1_id: session[:user_id])
  redirect "/game/play/#{game.id}"
end
