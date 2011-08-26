class Game < ActiveRecord::Base
  has_and_belongs_to_many :stats
  has_many :rounds, :dependent => :destroy

  validates_presence_of :player1, :total_rounds

  validates_numericality_of :total_rounds, only_integer: true, odd: true, greater_than_or_equal_to: 0
  #validates_numericality_of :rounds_played, only_integer: true, less_than_or_equal_to: :total_rounds
  #validates_numericality_of :winner, only_integer: true
  validates_numericality_of :player1, only_integer: true
  #validates_numericality_of :player2, only_integer: true


  THROW_OPTIONS = {"Rock" => 0, "Paper" => 1, "Scissor" => 2}

  def init
    @roundWin = -1
    @tied = false

    @pointsFor1 = 0
    @pointsFor2 = 0
    @throw1 = 0
    @throw2 = 0
    @rocks1 = 0
    @papers1 = 0
    @scissors1 = 0
    @rocks2 = 0
    @papers2 = 0
    @scissors2 = 0

    @curRound = 1
    @total_rounds = total_rounds ? total_rounds : 3
    @winIn = (@total_rounds / 2) + 1
    @player1 = player1
    @player2 = player2
  end


  def win1(throw1, throw2)
    @throw1 = throw1
    @throw2 = throw2
    @roundWin = 1
    @pointsFor1 += 1
    if @tied
       @tiePush += 1
       @tied = false
    end
  end

  def win2(throw1, throw2)
    @throw1 = throw1
    @throw2 = throw2
    @roundWin = 2
    @pointsFor2 += 1
    if @tied
       @tiePush += 1
       @tied = false
    end    
  end

  def tie(throw1, throw2)
    @throw1 = throw1
    @throw2 = throw2
    @roundWin = -1
    @tied = true
    @tiePush += 1
  end

  def play_round(options=nil)

    @curRound = rounds_played ? rounds_played : 1
    @total_rounds = total_rounds
    @winIn = (@total_rounds / 2) + 1
    @pointsFor1 = rounds.last ? rounds.last.curScore1 : 0
    @pointsFor2 = rounds.last ? rounds.last.curScore2 : 0
    @tied = rounds.last ? (rounds.last.winner == -1) : false
    @roundWin = -1
    @throw1 = 0
    @rocks1 = 0
    @papers1 = 0
    @scissors1 = 0
    @rocks2 = 0
    @papers2 = 0
    @scissors2 = 0
    @player1 = player1
    @player2 = player2
    @tiePush = @tied ?  rounds.last.tie : 0

    if options 
      theThrow1 = options[:play_round]
    else
      return false
    end

    pick1 = theThrow1.to_i
    pick2 = rand(3)

    #puts "pick 1: #{pick1}, pick 2: #{pick2}"

    case pick1
    when 0 then
      @rocks1 = 1
      case pick2 #rock
      when 0 then 
        @rocks2 = 1
        tie(pick1,pick2)
      when 1 then 
        @papers2 = 1
        win2(pick1,pick2)
      when 2 then 
        @scissors2 = 1
        win1(pick1,pick2)
      else #fail
      end
    when 1 then
      @papers1 = 1
      case pick2 #paper
      when 0 then 
        @rocks2 = 1
        win1(pick1,pick2)
      when 1 then 
        @papers2 = 1
        tie(pick1,pick2)
      when 2 then 
        @scissors2 = 1
        win2(pick1,pick2)
      else #fail
      end
    when 2 then 
      @scissors1 = 1
      case pick2 #scissor
      when 0 then 
        @rocks2 = 1
        win2(pick1,pick2)
      when 1 then 
        @papers2 = 1
        win1(pick1,pick2)
      when 2 then 
        @scissors2 = 1
        tie(pick1,pick2)
      else #fail
      end
    else puts "WHAT - not between 0..2!" #fail
    end

    #puts "#{@curRound}, #{@roundWin}, #{@throw1}, #{@throw2}, #{pick1}"
    #puts "#{@rocks1}, #{@papers1}, #{@scissors1}"
    
    round = rounds.build(num_round: @curRound, winner: @roundWin, 
    	    	         player1: @throw1, player2: @throw2, 
			 curScore1: @pointsFor1, curScore2: @pointsFor2, 
			 tie: @tiePush)
    round.save
    
    if not @tied
      if (@curRound >= @total_rounds) or @pointsFor1 >= @winIn or 
          @pointsFor2 >= @winIn
        gameOver = true
      else
        @curRound += 1
      end
      update_attribute(:rounds_played,@curRound)
    end



    if not gameOver
      return false
    else #gameOver
      if @pointsFor1 > @pointsFor2
        @winner = @player1
        @loser = @player2
        @win = Stats.find(@winner)
        @loss = Stats.find(@loser)

	#This logic should be in Stats...
        @win.rocks += rounds.where(player1: 0).count + @rocks1
        @win.papers += rounds.where(player1: 1).count + @papers1
        @win.scissors += rounds.where(player1: 2).count + @scissors1
        @loss.rocks +=  rounds.where(player2: 0).count + @rocks2
        @loss.papers += rounds.where(player2: 1).count + @papers2
        @loss.scissors += rounds.where(player2: 2).count + @scissors2
      else
        @winner = @player2
        @loser = @player1
        @win = Stats.find(@winner)
        @loss = Stats.find(@loser)
        
	#This logic should be in Stats...
        @win.rocks += rounds.where(player2: 0).count + @rocks2
        @win.papers += rounds.where(player2: 1).count + @papers2
        @win.scissors += rounds.where(player2: 2).count + @scissors2
        @loss.rocks += rounds.where(player1: 0).count + @rocks1
        @loss.papers += rounds.where(player1: 2).count + @papers1
        @loss.scissors += rounds.where(player1: 2).count + @scissors1
      end

      update_attributes(score1: @pointsFor1, score2: @pointsFor2, 
      		        winner: @winner)
      if save
        
        #TODO - add users to game after the game is played
        
        @win.win
        @win.games << self
        
        @loss.loss
        @loss.games << self
        
        @win.save
        @loss.save
        
        return true
      else #did not save...
        return false
      end
      
    end #gameOver

  end #play_round

  def to_s
      id
  end

  def first_to
    (total_rounds / 2) + 1 
  end

  def find_round(roundStr)
      r,t = roundStr.split('-')
      
      r = r.to_i
      t = t ? t.to_i : 0    
      
      rounds.find_by_num_round_and_tie(r,t)
  end

  def stats
      Stats.find(player1,player2,include: :user)
  end
      
end
