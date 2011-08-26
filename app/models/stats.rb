class Stats < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :games
  has_many :rounds, through: :games, group: "game.id"

  validates_presence_of :user_id

  validates_numericality_of :games_played, only_integer: true
  validates_numericality_of :wins, only_integer: true, less_than_of_equal_to: :games_played

  def win
    increment(:wins)
    increment(:games_played)
  end

  def loss
    increment(:games_played)
  end

end
