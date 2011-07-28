class Stats < ActiveRecord::Base
  belongs_to :user
  has_many :games
  has_many :rounds, :through => :games

  def win
    increment(:win)
    increment(:games_played)
  end

  def loss
    increment(:games_played)
  end

end
