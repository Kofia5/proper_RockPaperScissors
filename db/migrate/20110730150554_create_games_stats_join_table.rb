class CreateGamesStatsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :games_stats, :id => false do |t|
      t.integer :game_id
      t.integer :stats_id
    end
  end

  def self.down
    drop_table :games_stats
  end
end
