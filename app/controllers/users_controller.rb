class UsersController < ApplicationController
  def index
  
  end
  
  def create
    render text: "create" and return
    @user = User.new(user_params)
    if @user.save
      render json: @user.to_json
    else
      render json: {errors: @user.errors}
    end
  end

  def update
  end

  def show
  end
  
  def destroy
  end
  
  def hello
    render text: "hello"
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
