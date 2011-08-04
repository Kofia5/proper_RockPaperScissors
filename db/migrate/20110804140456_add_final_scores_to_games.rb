class AddFinalScoresToGames < ActiveRecord::Migration
  def self.up
    change_table :games do |t|
      t.integer :score1, :null => false
      t.integer :score2, :null => false
      end
  end

  def self.down
    change_table :games do |t|
      t.remove :score1
      t.remove :score2
    end
  end
end
