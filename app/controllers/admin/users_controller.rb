class Admin::UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    if current_user && is_admin?(current_user)
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_path, notice: "#{@user.firstname} #{@user.lastname} was created successfully!"
      else
        render :new
      end
    else
      redirect_to movies_path, alert: "Oops! You can't go here!"
    end
  end

  def index
    @user = current_user
    if @user && is_admin?(@user)
      @users = User.all.page(params[:page]).per(10)
      render :index
    else
      redirect_to movies_path, alert: "Oops! You can't go here!"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if current_user && is_admin?(current_user)
      @user = User.find(params[:id])
      if @user.update_attributes(user_params)
        redirect_to admin_users_path, notice: "#{@user.firstname} #{@user.lastname} was updated successfully!"
      else
        render :edit
      end
    else
      redirect_to movies_path, alert: "Oops! You can't go here!"
    end
  end

  def destroy
    @user = User.find(params[:id])
    UserMailer.farewell_email(@user).deliver_now
    @user.destroy
    redirect_to admin_users_path, notice: "Destroy successful"
  end

  def switch

  end

  protected

  def current_user
    User.find(session[:user_id])
  end

  def is_admin?(user)
    user.role == 'admin'
  end

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :role)
  end

  def switch_to_user(user_id)
    session[:admin_id] = session[:user_id]
    session[:user_id] = user_id
  end

  def switch_to_admin
    if session[:admin_id]
      session[:user_id] = session[:admin_id]
      session[:admin_id].delete
    end
  end

end
