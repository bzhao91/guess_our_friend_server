class GamesController < AuthController
  before_action :login?
  before_action :set_game
  
  def set_mystery_friend
    mystery_friend_id = params[:mystery_friend][:id]
    pool = params[:pool]
    valid_mystery_friend = false
    pool.each do |f|
      if f[:id] == mystery_friend_id
        valid_mystery_friend = true
        break
      end
    end
    if valid_mystery_friend == false
      render json: {errors: "Invalid mystery friend"}, :status => 822 and return
    end
    
    if @current_user.id == @game.player1id
      if @game.mystery_friend1 != -1
        render json: {errors: "You cannot change your mystery friend selection"}, :status => 821 and return
      end
      pool.each do |f|
        FriendPool.create(
          friend_id: f[:id],
          user_id: @current_user.id,
          game_id: @game.id
          )
      end
      @game.update_attribute(:mystery_friend1, mystery_friend_id)
    end
    if @current_user.id == @game.player2id
      if @game.mystery_friend2 != -1
        render json: {errors: "You cannot change your mystery friend selection"}, :status => 821 and return
      end
      pool.each do |f|
        FriendPool.create(
          friend_id: f[:id],
          user_id: @current_user.id,
          game_id: @game.id
          )
      end
      @game.update_attribute(:mystery_friend2, mystery_friend_id)
    end
    render json: {message: "Successfully commited friend pool and set mystery friend"}
  end
  
  def show_game_board
  
  
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
