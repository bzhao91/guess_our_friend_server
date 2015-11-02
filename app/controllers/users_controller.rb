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

  def update_rating
    #get new rating from front-end
    new_rating = params[:new_rating]
    total_rating = @user.rating * @user.number_ratings
    total_rating = total_rating + new_rating
    @user.update_attribute(:number_ratings, @user.number_ratings+1)
    @user.update_attribute(:rating, total_rating/@user.number_ratings)
  end
  
  def update_postmatch
    #need to include a way of identifying user
    if win
      @user.update_attribute(:matches_won,  @user.matches_won+1)
    else
      @user.update_attribute(:matches_lost, @user.matches_lost+1)
    end
    #calculate change in points
    @user.update_attribute(:points, @user.points+1)
  end

  def show_fb_id

  end
  
  def show_info
    
  end
  
  def destroy
  end
  
  private
    def user_params
      #needs update
      params.require(:user).permit(:name, :email)
    end
    
end
