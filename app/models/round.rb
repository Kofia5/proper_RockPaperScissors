class Round < ActiveRecord::Base
  belongs_to :game #, :include => :user

  validates_numericality_of :num_round, only_integer: true
  validates_numericality_of :winner, only_integer: true
  validates_numericality_of :player1, only_integer: true
  validates_numericality_of :player2, only_integer: true

  def to_s
      num_round.to_s + (tie > 0 ? "-"+tie.to_s : '')
  end

  #should be a way to do this without loading all rounds...
  def next_round
     pos =  game.rounds.index(self)+1
     pos >= 0 ? game.rounds[pos] : false
  end

  def prev_round
     pos =  game.rounds.index(self)-1
     pos >= 0 ? game.rounds[pos] : false
  end

end
