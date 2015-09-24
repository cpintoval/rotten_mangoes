class Admin::UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    if current_user && is_admin?(current_user)
      @user = User.new(user_params)
      if @user.save
        # session[:user_id] = @user.id # auto log in
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

  def destroy
    @user = User.find(params[:id])
    # respond_to do |format|
    UserMailer.farewell_email(@user).deliver_later
      # format.html { redirect_to(@user, notice: 'User was successfully deleted.') }
      # format.html { render action: 'new' }
    # end
    @user.destroy
    redirect_to admin_users_path, notice: "Destroy successful"
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

end
