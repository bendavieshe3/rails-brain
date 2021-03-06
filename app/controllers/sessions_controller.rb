class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to today_path
    else
      flash[:error] = 'User email or password is incorrect. Please try again.'
      redirect_to signin_path
    end
    
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
