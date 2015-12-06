require 'gcm'
class UsersController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?, :except => [:create, :index]
  
  def index
    render json: User.all
  end
  def create
    @user = User.new(user_params)
    if @user.save
      token = JWT.encode(@user, Rails.application.secrets.secret_key_base)
      render json: {user: @user, token: token}
    else
      #render json: { errors: @user.errors }
      #temporary stuff
      user = User.find_by_fb_id(params[:user][:fb_id])
      token = JWT.encode(user, Rails.application.secrets.secret_key_base)
      render json: {token: token }
    end
  end
  
  def send_message
    gcm = GCM.new("AIzaSyBG6sSHwD6XRgKIyN8dNzZa5HVzV1sCBB0")
    receiver = User.find_by_fb_id(params[:fb_id])
    gcm_ids = []
    if receiver.nil? || receiver.gcm_id.blank?
      render json: {errors: "Invalid receiver"}, :status => 830 and return
    end
    gcm_ids << receiver.gcm_id
    message = "This is a GCM message"
    options = {
      data: {
        title: "Notification",
        body:  message
      }
    }
    response = gcm.send(gcm_ids, options)
    render :json => {message: "successfully sent"}
  end
  
  def update_gcm_id
    @current_user.update_attribute(:gcm_id, params[:gcm_id])
    render json: {message: "Successfully updated the gcm id"}
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
    win = params[:win]
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
  
  # def friend_list
  #   render json: {friends: @current_user.friends}
  # end

  def destroy
    @user = User.find_by_fb_id(params[:fb_id])
    @user.destroy
    render json: {message: "Successfully deleted user"}
  end
  
  private
    def user_params
      #needs update
      params.require(:user).permit(:first_name, :last_name, :fb_id, :gcm_id)
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
