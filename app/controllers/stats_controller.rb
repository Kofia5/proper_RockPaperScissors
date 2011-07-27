class StatsController < ApplicationController

  def new
    @stat = Stats.new
  end

  def create
    @stat.save
  end

  def show
    current_user
    @user = @current_user
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stat }
    end
  end

end
