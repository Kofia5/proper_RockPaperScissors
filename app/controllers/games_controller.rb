class GamesController < ApplicationController

  before_filter :require_user, :only => [:setup, :update, :play, :destroy]

  def index
    current_user
    @games = Game.order('updated_at DESC')
  end

  def new
    setup
  end

  def create
    setup
  end

  def show
    @game = Game.find(params[:id])
    @winner = Stats.find(@game.winner).user.username
    @player1 = Stats.find(@game.player1).user.username
    @player2 = Stats.find(@game.player2).user.username
    @rounds = @game.rounds.order('rounds.id ASC')
    @throw_names = Game::THROW_OPTIONS.invert
  end

  def edit

  end

  def update
    @game = Game.find(params[:id])

    @game.playRound(params[:playRound])
    #respond_to do |format|
    #  if @game.update_attributes(params[:game])
    #    format.html { redirect_to(@gamer, :notice => 'Game was successfully updated.') }
    #    format.xml  { head :ok }
    #  else
    #    format.html { render :action => "edit" }
    #    format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
    #  end
    #end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(:back, :notice => "Game successfully deleted") }
      format.xml  { head :ok }
    end
  end

  def setup
    current_user
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
    @game = session[:game]
    @game.play(params[:game])

    session[:game] = nil
  end

  def playRound
    @user = session[:user]
    @game = session[:game]
    @game.play_round(params[:game])
    
    respond_to do |format|
      format.html { render 'play' }
      format.xml { render :xml => @game, :status => :roundplayed, :location => :@game }
    end
  end
end
