class AddCurrentScoresToRounds < ActiveRecord::Migration
  def self.up
    change_table :rounds do |t|
      t.integer :curScore1
      t.integer :curScore2
    end

  end

  def self.down
    change_table :rounds do |t|
      t.remove :curScore1
      t.remove :curScore2
    end

  end

end
