class AddTiesToRounds < ActiveRecord::Migration
  def self.up
    add_column :rounds, :tie, :integer, :default => 0
  end

  def self.down
    remove_column :rounds, :tie
  end
end
