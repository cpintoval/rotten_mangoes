class Admin::UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id # auto log in
      redirect_to movies_path, notice: "Welcome aboard, #{@user.firstname}!"
    else
      render :new
    end
  end

  def index
    @user = User.find(session[:user_id])
    if is_admin?(@user)
      @users = User.all.page(params[:page]).per(10)
      render :index
    else
      redirect_to movies_path, alert: "Oops! You can't go here!"
    end
  end

  protected

  def is_admin?(user)
    user.role == 'admin'
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :role)
  end

end
