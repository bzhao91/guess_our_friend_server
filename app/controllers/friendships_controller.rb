class FriendshipsController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?

  def friend_status
    friend = User.find(params[:friend_id]) #friend
    action = params[:option]
    if action.downcase != 'unfriend' && action.downcase != 'refriend'
      render json: {errors: 'Invalid option'}, :status => 801 and return
    end
    if friend
      friendship = Friendship.find_by_user_id_and_friend_id(@current_user.id, friend.id)
      if friendship
        if action == 'unfriend' && friendship.active == true
          friendship.update_attribute(:active, false)
          friendship = Friendship.find_by_user_id_and_friend_id(friend.id, @current_user.id)
          friendship.update_attribute(:active, false)
        elsif action == 'refriend' && friendship.active == false
          friendship.update_attribute(:active, true)
          friendship = Friendship.find_by_user_id_and_friend_id(friend.id, @current_user.id)
          friendship.update_attribute(:active, true)
        else
          render json: {errors: 'Invalid option'}, :status => 801 and return
        end
      end
    end
    render json: {message: "Successfully #{action.downcase == 'unfriend' ? 'unfriended' : 'refriended'} #{friend.first_name}"}
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
