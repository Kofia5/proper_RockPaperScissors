class RoundsController < ApplicationController
  before_filter :current_user

  def new
  end

  def index
      find_game(true)
      @rounds = @game.rounds
      @player1, @player2 = @game.stats
      @player1 = @player1.user
      @player2 = @player2.user
      @winner = @game.player1 == @game.winner ? @player1 : @player2
      @throw_names = Game::THROW_OPTIONS.invert
  end

  def edit
  end

  def update
  end

  def show
     find_game
     @round = @game.find_round(params[:id])
     @player1, @player2 = @game.stats
     @player1 = @player1.user
     @player2 = @player2.user
     @winner = case @round.winner
     	       	    when 1 then @player1
		    when 2 then @player2
		    else nil
		    end
     @throw_names = Game::THROW_OPTIONS.invert
  end

  def destroy
  end

  private

  def find_game(withRounds=false)
    if Game.exists?(params[:game_id])
      @game = withRounds ? Game.find(params[:game_id], include: :rounds) : 
      	      		   Game.find(params[:game_id])
    else
      errorMsg = "Game with ID=#{params[:game_id]} not found"
      redirect_to(games_url, notice: errorMsg)
      return
    end
  end

end
