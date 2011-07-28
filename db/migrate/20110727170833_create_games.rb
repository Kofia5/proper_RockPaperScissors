class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.integer :rounds_played
      t.integer :total_rounds
      t.integer :winner
      t.integer :player1, :null => false
      t.integer :player2

      t.timestamps
    end

    add_index :games, :winner
    add_index :games, :player1
  end

  def self.down
    drop_table :games
  end
end
