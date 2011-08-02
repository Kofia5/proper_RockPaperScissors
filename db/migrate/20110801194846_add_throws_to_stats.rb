class AddThrowsToStats < ActiveRecord::Migration
  def self.up
    change_table :stats do |t|
      t.integer :rocks,    :default => 0, :null => false
      t.integer :papers,   :default => 0, :null => false
      t.integer :scissors, :default => 0, :null => false
    end

  end

  def self.down
    change_table :stats do |t|
      t.remove :rocks
      t.remove :papers
      t.remove :scissors
    end

  end

end
