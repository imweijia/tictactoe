require 'byebug'
class Game < ActiveRecord::Base
  belongs_to :player1, class_name: 'User', foreign_key: 'player1_id'
  belongs_to :player2, class_name: 'User', foreign_key: 'player2_id'
  belongs_to :winner, class_name: 'User', foreign_key: 'winner_id'
  has_many :moves


  def status_string
    case status
    when 0
      "Waiting"
    when 1
      "Playing"
    when 2
      "Completed"
    end
  end

  def self.get_state(game)
    state = []
    count = 1
    state[0] = game.moves.count % 2
    9.times do
      if game.moves.find_by(move: count.to_s) != nil
        if game.moves.find_by(move: count.to_s).user_id == game.player1_id
          state[count] = "player1_x"
        elsif game.moves.find_by(move: count.to_s).user_id == game.player2_id
          state[count] = "player2_o"
        end
      else
          state[count] = ""
      end
      count += 1
    end

    if Game.get_winner(state) == "player1_x"
      state[0] = 2
      game.winner_id = game.player1_id
      game.save
    elsif Game.get_winner(state) == "player2_o"
      state[0] = 3
      game.winner_id = game.player2_id
      game.save
    end

    if !(state.include?(""))
      state[0] = 4
      game.winner_id = 0
      game.save
    end

    state
  end

  def self.get_winner(state)
      case 1
      when [state[1],state[2],state[3],"player1_x"].uniq.length
        winner = "player1_x"
      when [state[4],state[5],state[6],"player1_x"].uniq.length
        winner = "player1_x"
      when [state[7],state[8],state[9],"player1_x"].uniq.length
        winner = "player1_x"
      when [state[1],state[4],state[7],"player1_x"].uniq.length
        winner = "player1_x"
      when [state[2],state[5],state[8],"player1_x"].uniq.length
        winner = "player1_x"
      when [state[3],state[6],state[9],"player1_x"].uniq.length
        winner = "player1_x"
      when [state[1],state[5],state[9],"player1_x"].uniq.length
        winner = "player1_x"
      when [state[3],state[5],state[7],"player1_x"].uniq.length
        winner = "player1_x"
      when [state[1],state[2],state[3],"player2_o"].uniq.length
        winner = "player2_o"
      when [state[4],state[5],state[6],"player2_o"].uniq.length
        winner = "player2_o"
      when [state[7],state[8],state[9],"player2_o"].uniq.length
        winner = "player2_o"
      when [state[1],state[4],state[7],"player2_o"].uniq.length
        winner = "player2_o"
      when [state[2],state[5],state[8],"player2_o"].uniq.length
        winner = "player2_o"
      when [state[3],state[6],state[9],"player2_o"].uniq.length
        winner = "player2_o"
      when [state[1],state[5],state[9],"player2_o"].uniq.length
        winner = "player2_o"
      when [state[3],state[5],state[7],"player2_o"].uniq.length
        winner = "player2_o"
      else
        winner = "none"
      end


      winner
  end

end
