class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update, :destroy]

  # GET /users
  # GET /users.xml
  def index
    current_user
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    current_user
    @user = params[:id] ? User.find(params[:id]) : @current_user
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
        #flash[:notice] = "Account register!"
        #redirect_back_or_default account_url
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        #render :action => :new
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
        #flash[:notice] = "Account updated!"
        #redirect_to account_url
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
    current_user
    @user = User.find(params[:id])
    @games = Game.where("player1 = ? OR player2 = ?", params[:id], params[:id])

    respond_to do |format|
      format.html { render :action => 'list_games' }
      format.xml  { head :ok }
    end
  end
end
