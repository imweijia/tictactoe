class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.belongs_to :user
      t.belongs_to :game
      t.string :move
      t.timestamps
    end
  end
end
