class FriendPoolsController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?
  before_action :set_game
  
  def create
    if @current_user.id == @game.player1id && @game.mystery_friend1 != -1
      render json: {errors: "You cannot regenerate a new list since you have chosen the mystery friend"}, :status => 820 and return
    end
    if @current_user.id == @game.player2id && @game.mystery_friend2 != -1
      render json: {errors: "You cannot regenerate a new list since you have chosen the mystery friend"}, :status => 820 and return
    end
    query = "SELECT * FROM users WHERE users.id IN ((SELECT friend_id FROM friendships WHERE user_id = #{@game.player1id}) AS f1 INNER JOIN (SELECT friend_id FROM friendships WHERE user_id = #{@game.player2id}) AS f2 ON f1.friend_id = f2.friend_id)"
    render json: {message: query} and return
    mutual_friends = User.find_by_sql(query).to_a
    pool = mutual_friends.sample(25)
    render json: {results: pool}
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
  end
end
