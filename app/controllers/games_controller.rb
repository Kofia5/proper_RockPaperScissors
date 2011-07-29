class GamesController < ApplicationController

  before_filter :require_user, :only => [:setup, :update, :play, :destroy]

  def index
    current_user
    @games = Game.all
  end

  def new
    setup
  end

  def create
    setup
  end

  def show
    @game = Game.find(params[:id])
    @winner = User.find(@game.winner).username
    @player1 = User.find(@game.player1).username
    @player2 = User.find(@game.player2).username
    @rounds = Round.find_all_by_game_id(@game.id)
  end

  def edit

  end

  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to(@gamer, :notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
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
    @game = Game.new(:player1 => @user.id)
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

end
