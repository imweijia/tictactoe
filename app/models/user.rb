class User < ActiveRecord::Base
  has_many :moves
  has_many :won_games, class_name: 'Game', foreign_key:'winner_id'
  has_many :player1_games, class_name: 'Game', foreign_key:'player1_id'
  has_many :player2_games, class_name: 'Game', foreign_key:'player2_id'

  def authenticate(pw)
    self.password == pw
  end

  def self.valid?(username)
    User.exists?(username: username)
  end

  def total_games
    self.player1_games.count + self.player2_games.count
  end

  def myturn?(game_id)
    game = Game.find(game_id)
    if self.isHost?(game_id)
      if game.turn == 1
        return true
      end
    else
      if game.turn == 2
        return true
      end
    end
    return false
  end

  def isHost?(game_id)
    Game.find(game_id).player1.id == self.id
  end
end
