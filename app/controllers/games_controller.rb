class GamesController < ApplicationController

  before_filter :require_user, :only => [:setup, :update, :play, :destroy]
  before_filter :current_user

  def index
    @games = Game.where('winner IS NOT null')
    @header_option = "All Games"
  end

  def new
    @user = @current_user
    @player1 = @user.stats.id
    @game = Game.new
    session[:game] = @game
    respond_to do |format|
      format.html { render 'new' }
      format.xml { render :xml => @game, :status => :created, :location => :@game }
    end
  end

  def create
    @user = @current_user
    @player1 = @user.stats.id
    @game = session[:game]
    @options = params[:game]
    @player2 = User.find_by_username('theAI').stats.id
    if not @game.update_attributes(:player1 => @player1, :player2 => @player2, 
           		           :total_rounds => @options[:total_rounds])
      @game.delete
      flash[:notice] = "Must pick an odd, positive number of rounds!"
      redirect_to :action => :new
      return			   
    end
#    @game.init
    session[:game] = @game.id
    #@throw_names = Game::THROW_OPTIONS.invert
    respond_to do |format|
      format.html { playRound } #redirect_to :action => :playRound }
      format.xml { render :xml => @game, :status => :created, :location => :@game }
    end
  end

  def show
    if Game.exists?(params[:id])
      @game = Game.find(params[:id])
    else
      redirect_to(games_url, :notice => "Game with ID=#{params[:id]} not found")
      return
    end
        
    @winner = Stats.find(@game.winner).user
    @player1 = Stats.find(@game.player1).user
    @player2 = Stats.find(@game.player2).user
    @rounds = @game.rounds.order('rounds.id ASC')
    @throw_names = Game::THROW_OPTIONS.invert
  end

  def edit
    @game = Game.find(session[:game])
  end

  def update
    @game = Game.find(session[:game])

    respond_to do |format|
      if @game.play_round(params[:game])
        format.html { redirect_to(:action => :play)
        #redirect_to '/games#play' 
        }
        format.xml  { head :ok }
      else
        format.html { playRound
	  #redirect_to(:action => :playRound)
          #render :playRound
        }
        format.xml  { head :ok  }
      end
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(:index, :notice => "Game successfully deleted") }
      format.xml  { head :ok }
    end
  end

  def setup
    @user = @current_user
    @player1 = @user.stats.id
    @game = Game.new(:player1 => @player1)
    session[:game] = @game
    respond_to do |format|
      format.html { render 'setup' }
      format.xml { render :xml => @game, :status => :created, :location => :@game }
    end
  end

  def play
    @game = Game.find(session[:game])
    #@game.play()

    @winner = Stats.find(@game.winner).user
    session[:game] = nil
  end

  def playRound
    @user = @current_user
    @game = Game.find(session[:game])
    @throw_names = Game::THROW_OPTIONS.invert
    @curRound = @game.rounds_played ? @game.rounds_played : 1
    @showRounds = @game.rounds.any?

    respond_to do |format|
      format.html { render 'playRound' }
      format.xml { render :xml => @game, :status => :roundplayed, :location => :@game }
    end
  end
end
