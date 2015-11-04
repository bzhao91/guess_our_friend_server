class FriendshipsController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?
  def index
  
  end
  
  def update
  
  end

  def show
    
  end
  
  def unfriend
    friend = User.find(params[:friend_id]) #friend 
    if friend
      friendship = Friendship.find_by_user_id_and_friend_id(@current_user.id, friend.id)
      if friendship
        friendship.update_attribute(:active, false)
      end
      friendship = Friendship.find_by_user_id_and_friend_id(friend.id, @current_user.id)
      friendship.update_attribute(:active, false)
    end
    render json: {message: "Successfully unfriended #{friend.first_name}"}
  end
  
  def update_friend_list
    # request on facebook to get friends that installed the app
    friends = params[:friends]
    arr = friends[:data]
    arr.each do |f|
      friend = User.find_by_fb_id(f[:id])
      if friend
        friendship = Friendship.find_by_user_id_and_friend_id(@current_user.id, friend.id)
        unless friendship
          @current_user.friendships.create(friend_id: friend.id)
          friend.friendships.create(friend_id: @current_user.id)
        end
      end
    end
    query = "SELECT * FROM users WHERE users.id IN (SELECT friendships.friend_id FROM friendships WHERE friendships.user_id = '#{@current_user.id}' AND friendships.active = true)"
    render json: {friends: User.find_by_sql(query)}
  end
  
  private
    def login?
      unless @current_user
        render json: {errors: "Please log in"}, :status => 800
      end
    end
end
