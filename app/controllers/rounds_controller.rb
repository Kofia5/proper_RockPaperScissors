class RoundsController < ApplicationController
  before_filter :find_game

  def new
  end

  def index
      #@rounds = Round.find_all_by_game_id(params[:game_id])
      @rounds = @game.rounds
  end

  def edit
  end

  def update
  end

  def show
      #@round = Round.find(params[:id])
      #@round = @game.round(params[:id])
  end

  def destroy
  end

  private

  def find_game
     @game = Game.find(params[:game_id])
  end

end
