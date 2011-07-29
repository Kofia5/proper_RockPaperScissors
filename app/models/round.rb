class Round < ActiveRecord::Base
  belongs_to :game, :include => :user

  validates_numericality_of :num_round, :only_integer => true
  validates_numericality_of :winner, :only_integer => true
  validates_numericality_of :player1, :only_integer => true
  validates_numericality_of :player2, :only_integer => true
end
