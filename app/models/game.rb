class Game < ActiveRecord::Base
  has_and_belongs_to_many :stats
  has_many :rounds, :dependent => :destroy

  validates_presence_of :player1, :total_rounds

  validates_numericality_of :total_rounds, :only_integer => true
  validates_numericality_of :rounds_played, :only_integer => true, :less_than_or_equal_to => :total_rounds
  validates_numericality_of :winner, :only_integer => true
  validates_numericality_of :player1, :only_integer => true
  validates_numericality_of :player2, :only_integer => true


  THROW_OPTIONS = {"Rock" => 0, "Paper" => 1, "Scissor" => 2}

  def win1(throw1, throw2)
    @throw1 = throw1
    @throw2 = throw2
    @roundWin = 1
    @pointsFor1 += 1
    @tied = false
  end

  def win2(throw1, throw2)
    @throw1 = throw1
    @throw2 = throw2
    @roundWin = 2
    @pointsFor2 += 1
    @tied = false
  end

  def tie(throw1, throw2)
    @throw1 = throw1
    @throw2 = throw2
    @roundWin = -1
    @tied = true
  end

  def play(options)
    total_rounds = options[:total_rounds].to_i
    @player1 = player1
    
    if player2.nil?
      @player2 = User.find_by_username("theAI").stats.id
    end

    playing = true
    curRound = 1
    @pointsFor1 = 0
    @pointsFor2 = 0
    winIn = (total_rounds / 2) + 1
    @tied = false

    while playing
      #will allow actual play next (for now, random winner)
      pick1 = rand(3)
      pick2 = rand(3)

      case pick1
      when 0 then case pick2 #rock
                  when 0 then tie(pick1,pick2)
                  when 1 then win2(pick1,pick2)
                  when 2 then win1(pick1,pick2)
                  else #fail
                  end
      when 1 then case pick2 #paper
                  when 0 then win1(pick1,pick2)
                  when 1 then tie(pick1,pick2)
                  when 2 then win2(pick1,pick2)
                  else #fail
                  end
      when 2 then case pick2 #scissor
                  when 0 then win1(pick1,pick2)
                  when 1 then win2(pick1,pick2)
                  when 2 then tie(pick1,pick2)
                  else #fail
                  end
      else #fail
      end

      rounds.build(:num_round => curRound, 
                   :winner => @roundWin, :player1 => @throw1,
                   :player2 => @throw2)
      if not @tied
        if curRound >= total_rounds or @pointsFor1 >= winIn or 
           @pointsFor2 >= winIn
          playing = false
        else
          curRound += 1
        end
      end
    end

    if @pointsFor1 > @pointsFor2
      @winner = @player1
      @loser = @player2
    else
      @winner = @player2
      @loser = @player1
    end  

    update_attributes(:player2 => @player2, :winner => @winner, 
                      :total_rounds => total_rounds, :rounds_played => curRound)
    save


    #TODO - add users to game after the game is played
    @win = Stats.find(@winner)
    @win.win
    @win.games << self
    @loss = Stats.find(@loser)
    @loss.loss
    @loss.games << self

    @win.save
    @loss.save
  end


  def playRound(theThrow=0)

  end

end
