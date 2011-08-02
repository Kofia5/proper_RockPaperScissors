class AddMoreIndices < ActiveRecord::Migration
  def self.up
    add_index :stats, :user_id
  end

  def self.down
    remove_index :stats, :user_id
  end
end
