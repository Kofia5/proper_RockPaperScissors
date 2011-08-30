class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy

  def new
    if current_user
       redirect_back_or_default account_url
    else 
       @user_session = UserSession.new
    end
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_url
    else
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    @current_user = nil
    flash[:notice] = "Logout successful!"
    redirect_back_or_default login_url
  end

end
