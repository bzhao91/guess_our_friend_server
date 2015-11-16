class GamesController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?
  before_action :set_game, :except => [:show_all_games]
  
  def set_mystery_friend
    # mystery_friend_id = params[:mystery_friend][:id]
    # pool = params[:pool]
    # valid_mystery_friend = false
    # pool.each do |f|
    #   if f[:id] == mystery_friend_id
    #     valid_mystery_friend = true
    #     break
    #   end
    # end
    # if valid_mystery_friend == false
    #   render json: {errors: "Invalid mystery friend"}, :status => 822 and return
    # end
    
    # if @current_user.id == @game.player1id
    #   if @game.mystery_friend1 != -1
    #     render json: {errors: "You cannot change your mystery friend selection"}, :status => 821 and return
    #   end
    #   pool.each do |f|
    #     FriendPool.create(
    #       friend_id: f[:id],
    #       user_id: @current_user.id,
    #       game_id: @game.id
    #       )
    #   end
    #   @game.update_attribute(:mystery_friend1, mystery_friend_id)
    # end
    # if @current_user.id == @game.player2id
    #   if @game.mystery_friend2 != -1
    #     render json: {errors: "You cannot change your mystery friend selection"}, :status => 821 and return
    #   end
    #   pool.each do |f|
    #     FriendPool.create(
    #       friend_id: f[:id],
    #       user_id: @current_user.id,
    #       game_id: @game.id
    #       )
    #   end
    #   @game.update_attribute(:mystery_friend2, mystery_friend_id)
    # end
    
    
    #render json: {message: "Successfully commited friend pool and set mystery friend"}
  end
  
  def show_game_board
    #show the question history, outgoing questions, incoming questions
    #show current user's friend pool and people that have been greied out
    outgoing_questions = Question.find_by_game_id_and_user_id(@game.id,  @current_user.id)
    incoming_questions = Question.find_by_game_id_and_user_id(@game.id,  @opponent_id)
    #render json: {outgoing_questions: outgoing_questions} and return
    incoming_list = FriendPool.find_by_game_id_and_user_id(@game.id, @opponent_id)
    # query_incoming = "SELECT users.first_name, users.last_name, pools.grey FROM (SELECT * FROM friend_pools WHERE user_id = #{@opponent_id} AND game_id = #{@game.id}) AS pools INNER JOIN users ON users.id = pools.friend_id"
    # incoming_list = User.find_by_sql(query_incoming)
   
    #query_outgoing = "SELECT users.first_name, users.last_name FROM (SELECT * FROM friend_pools WHERE user_id = #{@opponent_id} AND game_id = #{@game.id}) AS pools INNER JOIN users ON users.id = pools.friend_id"
    #outgoing_list = User.find_by_sql(query_outgoing)
    
    outgoing_list = FriendPool.find_by_game_id_and_user_id(@game.id, @opponent_id)
    #render json: {list: outgoing_list} and return
    mystery_friend_id = @current_user.id == @game.player1id ? @game.mystery_friend1 : @game.mystery_friend2
    #mystery_friend = User.find_by_id(mystery_friend_id)
    mystery_friend = FriendPool.find_by_id(mystery_friend_id)
    questions = {outgoing_questions: outgoing_questions, incoming_questions: incoming_questions}
    friend_lists = {outgoing_list: outgoing_list, incoming_list: incoming_list}
    render json: {result: {questions: questions, friend_list: friend_lists, mystery_friend: mystery_friend}}
  end
  
  def show_all_games
    query = "SELECT * FROM (SELECT id as game_id, player2id FROM games WHERE player1id = #{@current_user.id}) AS g INNER JOIN users on g.player2id = users.id"
    results = User.find_by_sql(query)
    render json: {results: results}
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
end
