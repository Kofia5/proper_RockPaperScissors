class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update, :destroy]
  before_filter :current_user

  # GET /users
  # GET /users.xml
  def index
    @users = User.all(include: :stats)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    if params[:id]
       if User.exists?(params[:id])
       	  @user = User.find(params[:id], include: :stats)
       else
          redirect_to(users_url, :notice => "User with ID=#{params[:id]} not found")
	  return
       end
    else #no id
       @user = @current_user
    end

    @total_throws = (@user.stats.rocks + @user.stats.papers + 
      @user.stats.scissors)
    if @total_throws > 0
      @rock_percent = (@user.stats.rocks.fdiv(@total_throws))*100
      @paper_percent = (@user.stats.papers.fdiv(@total_throws))*100
      @scissor_percent = (@user.stats.scissors.fdiv(@total_throws))*100
    end
    @rounds = @user.rounds(10,true)
    @throw_names = Game::THROW_OPTIONS.invert
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @user.stats = Stats.new
    @stats = @user.stats
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = @current_user
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @stats = Stats.new
    @user.stats = @stats
    respond_to do |format|
      if @user.save && @stats.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }

      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = @current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        #render :action => :edit
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = @current_user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def list_games
    @user = User.find(params[:id])
    @header_option = 'games'
    @games = @user.games

    respond_to do |format|
      format.html { render "games/index" }
      format.xml  { head :ok }
    end
  end

  def list_wins
    @header_option = 'wins'
    @user = User.find(params[:id])
    @games = @user.games_won

    respond_to do |format|
      format.html { render "games/index" }
      format.xml  { head :ok }
    end
  end

  def list_losses
    @header_option = 'losses'
    @user = User.find(params[:id])
    @games = @user.games_lost

    respond_to do |format|
      format.html { render "games/index" }
      format.xml  { head :ok }
    end
  end

end
