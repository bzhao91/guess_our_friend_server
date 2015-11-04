class FriendshipsController < AuthController
  before_action :login?
  def index
  
  end
  
  def update
  
  end

  def show
    
  end
  
  def destroy
  
  end
  
  
  def update_friend_list
    # request on facebook to get friends that installed the app
    friends = params[:friends]
    arr = friends['data']
    arr.each do |f|
      friend = User.find_by_fb_id(f['id'])
      if friend
        friendship = Friendship.find_by_user_id_and_friend_id(@current_user.id, friend.id)
        unless friendship
          @current_user.friendships.create(:friend_id, friend.id)
          friend.friendships.create(:friend_id, @current_user.id)
        end
      end
    end
    
    render json: {friends: @current_user.friends}
  end
  
  private
    def login?
      unless @current_user
        render json: {errors: "Please log in"}, :status => 800
      end
    end
end
