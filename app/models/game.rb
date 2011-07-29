class Game < ActiveRecord::Base
  has_many :stats
  has_many :rounds

  validates_presence_of :player1, :total_rounds

  validates_numericality_of :total_rounds, :only_integer => true
  validates_numericality_of :rounds_played, :only_integer => true, :less_than_or_equal_to => :total_rounds
  validates_numericality_of :winner, :only_integer => true
  validates_numericality_of :player1, :only_integer => true
  validates_numericality_of :player2, :only_integer => true


  THROW_OPTIONS = [[0,0],[1,1]]

  def play(options)
    total_rounds = options[:total_rounds].to_i
    @player1 = player1
    
    if player2.nil?
      @player2 = User.find_by_username("theAI").id
    end

    playing = true
    curRound = 1
    pointsFor1 = 0
    pointsFor2 = 0
    winIn = (total_rounds / 2.0).ceil

    while playing
      #will implement proper rules later (for now, random winner)
      if rand > 0.5
        throw1 = 1
        throw2 = 0
        roundWin = 1
        pointsFor1 += 1
      else
        throw1 = 0
        throw2 = 1
        roundWin = 2
        pointsFor2 += 1
      end
      round = Round.new(:game_id => id, :num_round => curRound, 
                        :winner => roundWin, :player1 => throw1, 
                        :player2 => throw2)
      round.save
      rounds << round
      if curRound >= total_rounds or pointsFor1 >= winIn or 
          pointsFor2 >= winIn
        playing = false
      else
        curRound += 1
      end
    end

    @winner = pointsFor1 > pointsFor2 ? @player1 : @player2
    @loser = (@winner == @player1) ? @player2 : @player1

    update_attributes(:player2 => @player2, :winner => @winner, 
                      :total_rounds => total_rounds, :rounds_played => curRound)
    save

    @win = Stats.find_by_user_id(@winner)
    @win.win
    @loss = Stats.find_by_user_id(@loser)
    @loss.loss

    @win.save
    @loss.save
  end

  def destroy
    rounds.destroy
    destroy
  end
    
end
