class SessionsController < ApplicationController
  skip_before_action :unauthorized

  def new
  end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to_desire_page(user)
    else
      render :new, notice: 'Password or email is invalid.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to sessions_new_path, notice: 'Signed out successfully.'
  end

  private

  def redirect_to_desire_page(user)
    if user.has_role? :admin
      redirect_to admin_users_path, notice: 'Signed in successfully.'
    else
      redirect_to root_path, notice: 'Signed in successfully.'
    end
  end
end
