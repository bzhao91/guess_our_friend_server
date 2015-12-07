class GamesController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?
  before_action :set_game, :except => [:show_all_games, :match_making, :remove_from_match_making, :check_match_making]
  
  def match_making
    friends_ids = params[:friends]
    friends = []
    unless friends_ids.present?
      render json: {errors: "Invalid parameter in matchmaking."}, :status => 888
      return
    end
    friends_ids.each do |id|
      f = User.find_by_fb_id(id)
      if f.present? && f.match_making.nil? == false
        friends << f
      end
    end
    while friends.count > 0
      friends.sort_by{|x| x.match_making}
      if Game.where(player1id: @current_user.id, player2id: friends.first.id).present? || Game.where(player1id: friends.first.id, player2id: @current_user.id).present?
        friends.delete_at(0)
      else
        g = Game.create(player1id: friends.first.id, player2id: @current_user.id)
        User.find_by_id(friends.first.id).update_attribute(:match_making, nil)
        game_hash = JSON.parse(g.to_json)
        game_hash['player1id'] = User.find_by_id(g.player1id).fb_id
        game_hash['player2id'] = User.find_by_id(g.player2id).fb_id
        send_gcm_message(friends.first.gcm_id, "Your friend #{@current_user.first_name} started a game with you!", game_hash.to_json)
        render json: {game: game_hash, message: "Successfully found a friend."} and return
      end
    end
    if @current_user.match_making.nil?
      @current_user.update_attribute(:match_making, Time.now)
      render json: {message: "There are no available friends in the matchmaking pool. You have been placed in the pool."}
    else
      render json: {message: "You are already in the matchmaking pool."}
    end
  end
  
  def grey_out
    friend = FriendPool.where(game_id: @game.id, user_id: @current_user.id, fb_id: params[:fb_id])
    if friend.blank?
      render json: {errors: "Friend not found."}, :status => 889 and return
    end
    friend.first.update_attribute(:grey, true)
    render json: {message: "Successfully greyed out the selected friend."}
  end
  
  def ungrey
    friend = FriendPool.where(game_id: @game.id, user_id: @current_user.id, fb_id: params[:fb_id])
    if friend.blank?
      render json: {errors: "Friend not found."}, :status => 889 and return
    end
    friend.first.update_attribute(:grey, false)
    render json: {message: "Successfully ungreyed the selected friend."}
  end
  
  
  def remove_from_match_making
    @current_user.update_attribute(:match_making, nil)
    render json: {message: "Successfully removed yourself from the matchmaking pool."}
  end
  
  def check_match_making
    render json: { results: @current_user.match_making.nil? ? false : true}
  end
  
  def show_game_board
    #show the question history, outgoing questions, incoming questions
    #show current user's friend pool and people that have been greied out
    outgoing_questions = Question.where(game_id: @game.id,  user_id: @current_user.id)
    incoming_questions = Question.where(game_id: @game.id,  user_id: @opponent_id)
    #render json: {outgoing_questions: outgoing_questions} and return
    incoming_list = FriendPool.where(game_id: @game.id, user_id: @opponent_id)
    # query_incoming = "SELECT users.first_name, users.last_name, pools.grey FROM (SELECT * FROM friend_pools WHERE user_id = #{@opponent_id} AND game_id = #{@game.id}) AS pools INNER JOIN users ON users.id = pools.friend_id"
    # incoming_list = User.find_by_sql(query_incoming)
   
    #query_outgoing = "SELECT users.first_name, users.last_name FROM (SELECT * FROM friend_pools WHERE user_id = #{@opponent_id} AND game_id = #{@game.id}) AS pools INNER JOIN users ON users.id = pools.friend_id"
    #outgoing_list = User.find_by_sql(query_outgoing)
    
    outgoing_list = FriendPool.where(game_id: @game.id, user_id: @current_user.id)
    #render json: {list: outgoing_list} and return
    mystery_friend_id = @current_user.id == @game.player1id ? @game.mystery_friend1 : @game.mystery_friend2
    #mystery_friend = User.find_by_id(mystery_friend_id)
    mystery_friend = FriendPool.find_by_id(mystery_friend_id)
    questions = {outgoing_questions: outgoing_questions, incoming_questions: incoming_questions}
    friend_lists = {outgoing_list: outgoing_list, incoming_list: incoming_list}
    your_turn = false
    if @current_user.id == @game.player1id && @game.active_move == true || @current_user.id == @game.player2id && @game.active_move == false
      your_turn = true
    end
    render json: {results: {questions: questions, friend_list: friend_lists, mystery_friend: mystery_friend, your_turn: your_turn}}
  end
  
  def show_all_games
    query_incoming = "SELECT users.id AS user_id, first_name, last_name, fb_id, g.id as game_id, g.state FROM (SELECT * FROM games WHERE player1id = #{@current_user.id}) AS g INNER JOIN users on g.player2id = users.id"
    results_incoming = User.find_by_sql(query_incoming)
    query_outgoing = "SELECT users.id AS user_id, first_name, last_name, fb_id, g.id as game_id, g.state FROM (SELECT * FROM games WHERE player2id = #{@current_user.id}) AS g INNER JOIN users on g.player1id = users.id"
    results_outgoing = User.find_by_sql(query_outgoing)
    results = {incoming_games: results_incoming, outgoing_games: results_outgoing}
    render json: {results: results}
  end
  
  def set_done
    if @game.state != 2
      render json: {errors: "You cannot finish a ongoing game"}, :status => 999 and return
    end
    if @current_user.id == @game.player1id 
      @game.update_attribute(:player1done, true)
    else
      @game.update_attribute(:player2done, true)
    end
    if @game.player1done == true && @game.player2done == true
      @game.destroy
      render json: {message: "Successfully ended the game."} and return
    end  
    render json: {message: "You have ended the game."}
  end
  
  def player_quit
    @game.update_attribute(:state, 2)
    opponent = @current_user.id == @game.player1id ? User.find_by_id(@game.player2id) : User.find_by_id(@game.player1id)
    send_gcm_message(opponent.gcm_id, "#{@current_user.first_name} left the game!", "You win!")
    render json:{message: "Successfully quit the game."}
  end
  
  def reveal_mystery_friend
    if @game.state != 2
      render json: {errors: "You cannot finish a ongoing game"}, :status => 999 and return
    end 
    if @current_user.id == @game.player1id 
      render json: {mystery_friend: FriendPool.find_by_id(@game.mystery_friend2).fb_id}
    else
      render json: {mystery_friend: FriendPool.find_by_id(@game.mystery_friend1).fb_id}
    end
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
    @opponent_id = @current_user.id == @game.player1id ? @game.player2id : @game.player1id
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
