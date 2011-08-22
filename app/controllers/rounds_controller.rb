class RoundsController < ApplicationController
  before_filter :find_game, :current_user

  def new
  end

  def index
      @rounds = @game.rounds
      @winner = Stats.find(@game.winner).user
      @player1 = Stats.find(@game.player1).user
      @player2 = Stats.find(@game.player2).user
      @throw_names = Game::THROW_OPTIONS.invert
  end

  def edit
  end

  def update
  end

  def show
     #@round = Round.find(params[:id])
     curRound, tie = params[:id].split('-')
     @round = @game.rounds[curRound.to_i + (tie ? tie.to_i-1 : 0)]
     @player1 = Stats.find(@game.player1).user
     @player2 = Stats.find(@game.player2).user
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

  def find_game
     @game = Game.find(params[:game_id])
  end

end
