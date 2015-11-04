class UsersController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?, :except => [:create]
  
  def create
    @user = User.new(user_params)
    if @user.save
      token = JWT.encode(@user, Rails.application.secrets.secret_key_base)
      render json: {user: @user, token: token}
    else
      render json: {errors: @user.errors}
    end
  end
  
  def signup_fb
    
    
    
  end

  def update_rating
    #get new rating from front-end
    new_rating = params[:new_rating]
    total_rating = @current_user.rating * @current_user.number_ratings
    total_rating = total_rating + new_rating
    @current_user.update_attribute(:number_ratings, @current_user.number_ratings+1)
    @current_user.update_attribute(:rating, total_rating/@current_user.number_ratings)
  end
  
  def update_postmatch
    #need to include a way of identifying user
    if win
      @current_user.update_attribute(:matches_won,  @current_user.matches_won+1)
    else
      @current_user.update_attribute(:matches_lost, @current_user.matches_lost+1)
    end
    #calculate change in points
    @current_user.update_attribute(:points, @current_user.points+1)
  end

  def show
    render json: @current_user.to_json
  end
  
  def destroy
  end
  
  private
    def user_params
      #needs update
      params.require(:user).permit(:first_name, :last_name, :fb_id)
    end
    
    def login?
      unless @current_user
        render json: {errors: "Please log in"}, :status => 800
      end
    end
    
    def get_fb_user(access_token)
      RestClient.get 'https://graph.facebook.com//v2.3/me', :params => { :access_token => access_token}
    end
    
    
end
