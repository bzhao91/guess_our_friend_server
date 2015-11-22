class FriendPoolsController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?
  before_action :set_game
  
  def create
    # if @current_user.id == @game.player1id && @game.mystery_friend1 != -1
    #   render json: {errors: "You cannot regenerate a new list since you have chosen the mystery friend"}, :status => 820 and return
    # end
    # if @current_user.id == @game.player2id && @game.mystery_friend2 != -1
    #   render json: {errors: "You cannot regenerate a new list since you have chosen the mystery friend"}, :status => 820 and return
    # end
    # query = "SELECT * FROM users WHERE id IN (SELECT f1.friend_id FROM (SELECT friend_id FROM friendships WHERE user_id = #{@game.player1id}) AS f1 INNER JOIN (SELECT friend_id FROM friendships WHERE user_id = #{@game.player2id}) AS f2 ON f1.friend_id = f2.friend_id)"
    # #if its fewer than 25 friends - then there is a separate database of famous people - 
    # mutual_friends = User.find_by_sql(query).to_a
    # pool = mutual_friends.sample(25)
    # render json: {results: pool}
    
    
    #user id, game id, friend id
    pool = params[:friend_pool]
    if pool.blank?
      render json: {errors: "Parameter missing in friend pool create"}, :status => 820 and return
    end
    if FriendPool.find_by_game_id_and_user_id(@game.id, @current_user.id).present?
      render json: {errors: "You cannot reselected a guessing list"}, :status => 821 and return
    end
    ms = false
    pool.each do |f|
      if f[:mystery_friend] == true || f[:mystery_friend] == "true"
        ms = true
        break
      end
    end
    
    if ms == false
      render json: {errors: "Mystery friend is not selected"}, :status => 820 and return
    end
    
    pool.each do |f|
      tf = FriendPool.create(
        user_id: @current_user.id,
        first_name: f[:first_name],
        last_name: f[:last_name],
        game_id: @game.id
        )
      if @cur_as_p1 == true
        if (f[:mystery_friend] == true || f[:mystery_friend] == 'true') && @game.mystery_friend1 == -1
          @game.update_attribute(:mystery_friend1, tf.id)
        end
      else
        if (f[:mystery_friend] == true || f[:mystery_friend] == 'true') && @game.mystery_friend2 == -1
          @game.update_attribute(:mystery_friend2, tf.id)
        end
      end
    end
    friend_pool = FriendPool.where(game_id: @game.id, user_id: @current_user.id)
    friends = []
    friend_pool.each do |f|
      friends << JSON.parse(f.to_json(:except => [:created_at, :updated_at, :user_id, :game_id, :grey]))
    end
    send_gcm_message(@opponent.gcm_id, "Guess the Mystery Friend!", {pool: friends, game: @game.id}.to_json)
    render json: {result: friend_pool, game: @game}
  end

private
  def login?
    unless @current_user
      render json: {errors: "Please log in"}, :status => 800
    end
  end
  
  def set_game
    @game = Game.find_by_id(params[:game_id])
    unless @game
        render json: {errors: "Game does not exist"}, :status => 810 and return
    end
    if @current_user.id != @game.player1id && @current_user.id != @game.player2id
        render json: {errors: "Invalid game"}, :status => 811 and return
    end
    @cur_as_p1 = @current_user.id == @game.player1id ? true : false
    @opponent  = @current_user.id == @game.player1id ? User.find_by_id(@game.player2id) : User.find_by_id(@game.player1id)
    if @opponent.blank?
        render json: {errors: "Invalid game, opponent does not exist"} and return
    end
  end
  
  def send_gcm_message(gcm_id, title, content)
      gcm = GCM.new("AIzaSyBG6sSHwD6XRgKIyN8dNzZa5HVzV1sCBB0")
      gcm_ids = []
      gcm_ids << gcm_id
      message = content
      options = {
        data: {
          title: title,
          body:  message
        }
      }
      response = gcm.send(gcm_ids, options)
  end
end
