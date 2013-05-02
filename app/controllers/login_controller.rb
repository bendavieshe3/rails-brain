class LoginController < ApplicationController

  include SessionHelper

  # show the login screen
  def show

  end

  # create an account
  def create
    @user = User.new(params[:user])
    @user.password = params[:password]
    @user.save!
  end

  #perform an actual login
  def login
    @user = User.find_by_email_address(params[:emailaddress])

    if @user && @user.password == params[:password]
      sign_in(@user)
      redirect_to root_path, notice: "You have successfully signed in as #{@user.email_address}"
    else
      flash[:error] = "Invalid username or password"
      redirect_to root_path
    end
  end

  #perform a logout
  def logout

  end

  private

end
