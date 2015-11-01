class UsersController < ApplicationController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  def index
  
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user.to_json
    else
      render json: {errors: @user.errors}
    end
  end
  
  def signup_fb
    
  end

  def update
  end

  def show
    
  end
  
  def destroy
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email)
    end
    
end
