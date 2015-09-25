class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to movies_path, notice: "Welcome back, #{user.firstname}!"
    else
      flash.now[:alert] = "Log in failed..."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to movies_path, notice: "Adios!"
  end

  def update
    if session[:admin_id] == nil
      # Go back to Admin Profile
      user = User.find(params[:switch_id])
      switch_to_user(params[:switch_id])
      redirect_to movies_path, notice: "Switched to #{user.firstname} #{user.lastname}"
    else
      # Switch to selected User
      switch_to_admin
      redirect_to admin_users_path, notice: "Switched back to Admin"
    end
  end

  protected

  def switch_to_user(user_id)
    session[:admin_id] = session[:user_id]
    session[:user_id] = user_id
  end

  def switch_to_admin
    if session[:admin_id]
      session[:user_id] = session[:admin_id]
      session[:admin_id] = nil
    end
  end

end
