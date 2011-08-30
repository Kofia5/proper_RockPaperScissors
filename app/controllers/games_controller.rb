class GamesController < ApplicationController

  before_filter :require_user, only: [:setup, :update, :play, :destroy]
  before_filter :current_user, not: [:setup, :update, :play, :destroy]

  def index
    @games = Game.where('winner IS NOT null').order('updated_at DESC')
    @header_option = "All Games"
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render xml: @games }
    end
  end

  def new
    @user = @current_user
    @player1 = @user.stats.id
    @game = Game.new
    session[:game] = @game
    respond_to do |format|
      format.html { render 'new' }
      format.xml { render xml: @game, status: :created, location: :@game }
      format.js
    end
  end

  def create
    @user = @current_user
    @player1 = @user.stats.id
    @game = session[:game]
    @options = params[:game]
    @player2 = User.find_by_username('theAI').stats.id
    if not @game.update_attributes(player1: @player1, player2: @player2, 
           		           total_rounds: @options[:total_rounds])
      @game.delete
      flash[:notice] = "Must pick an odd, positive number of rounds!"
      redirect_to :action => :new
      return			   
    end

    @prevThrow = 0
    session[:game] = @game.id

    respond_to do |format|
      format.html { playRound }
      format.xml { render xml: @game, status: :created, location: :@game }
      format.js 
    end
  end

  def show
    if Game.exists?(params[:id])
      @game = Game.find(params[:id], include: :rounds)
    else
      redirect_to(games_url, notice: "Game with ID=#{params[:id]} not found")
      return
    end
        
    @player1, @player2 = @game.stats
    @player1 = @player1.user
    @player2 = @player2.user
    @winner = @game.player1 == @game.winner ? @player1 : @player2
    @rounds = @game.rounds
    @throw_names = Game::THROW_OPTIONS.invert
  end

  def edit
    @game = Game.find(session[:game])
  end

  def update
    @game = Game.find(session[:game])
    @prevThrow = params[:game] ? params[:game][:play_round].to_i : 0
    
    respond_to do |format|
      if @game.play_round(params[:game])
        format.html { redirect_to(:action => :play) }
        format.xml  { head :ok }
      else
        format.html { playRound }
        format.xml  { head :ok }
      end
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
          format.html { redirect_to(:index, notice: "Game successfully deleted") }
      format.xml  { head :ok }
    end
  end

  def setup
    @user = @current_user
    @player1 = @user.stats.id
    @game = Game.new(player1: @player1)
    session[:game] = @game
    respond_to do |format|
      format.html { render 'setup' }
      format.xml { render xml: @game, status: :created, location: @game }
    end
  end

  def play
    @game = Game.find(session[:game])

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
      format.xml { render xml: @game, status: :roundplayed, location: @game }
    end
  end

  def delete_incomplete
    @incompleteGames = Game.where('winner IS null')
    @incompleteGames.each do |game|
      game.delete
    end
    redirect_back_or_default account_path
  end

end
