class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.belongs_to :game
      t.integer :num_round
      t.integer :winner,  :null => false
      t.integer :player1, :null => false
      t.integer :player2, :null => false

      t.timestamps
    end
    
    add_index :rounds, :game_id
    
  end

  def self.down
    drop_table :rounds
  end
end
