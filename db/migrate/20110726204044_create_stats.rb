class CreateStats < ActiveRecord::Migration
  def self.up
    create_table :stats do |t|
      t.integer :wins,         :null => false, :default => 0
      t.integer :games_played, :null => false, :default => 0
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :stats
  end
end
