class ChallengesController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?
  def create
    challengee = User.find_by_fb_id(params[:challengee_fb_id])
    unless challengee
      render json: {errors: "Opponent does not exist"}, :status => 802
      return
    end
    
    if challengee.id == @current_user.id
      render json: {errors: "You cannot challenge yourself"}, :status => 803 and return
    end
    # unless Friendship.find_by_user_id_and_friend_id(@current_user.id, challengee.id)
    #   render json: {errors: "Opponent is not your friend"}, :status => 803 and return
    # end
      #the person you are challenging has already challenged you
    if Challenge.find_by_challenger_id_and_challengee_id(challengee.id, @current_user.id)
      render json: {errors: "Your opponent has already challenged you"}, :status => 804 and return
    end
    challenge = @current_user.sending_challenges.build(challengee_id: challengee.id)
    #render json: challenge and return 
    if challenge.save
      content_hash = Hash.new
      content_hash['challenger_fb_id'] = User.find_by_id(challenge.challenger_id).fb_id
      send_gcm_message(challengee.gcm_id, "Your Friend #{@current_user.first_name} has challenged you", content_hash.to_json)
      render json: challenge.to_json
    else
      render json: {errors: "There is already an pending challenge between you and your friend"}, :status => 805
    end
  end
  
  def challengee_respond
    #two ways
    accept = params[:accept]

    challenger = User.find_by_id(params[:challenger_id])
    unless challenger
      render json: {errors: "Challenger does not exist"}, :status => 806 and return
    end
    challenge = Challenge.find_by_id(params[:challenge_id])
    unless challenge
      render json: {errors: "Challengedf does not exist"}, :status => 806 and return
    end
    if challenge.challengee_id.to_i != @current_user.id || challenge.challenger_id.to_i != challenger.id
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    ongoing_game = nil
    if accept == true || accept == 'true'
      #Game create
      if (ongoing_game = accept_game(challenger)) == false
        return
      end
      send_gcm_message(challenger.gcm_id, "Your friend #{@current_user.first_name} has accepted your challenge", ongoing_game.to_json)
    else
      #send out decline message
      send_gcm_message(challenger.gcm_id, "Your friend #{@current_user.first_name} has rejected your challenge", "")
    end
    challenge.destroy
    if accept == true || accept == 'true'
      render json: ongoing_game.to_json
    else
      render json: {message: "Successfully rejected the challenge"}
    end
  end
  
  def challenger_respond
    challengee = User.find_by_id(params[:challengee_id])
    unless challengee
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    challenge = Challenge.find_by_id(params[:challenge_id])
    unless challenge
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    if challenge.challengee_id.to_i != challengee.id || challenge.challenger_id.to_i != @current_user.id
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    challenge.destroy
    send_gcm_message(challengee.gcm_id, "Your friend #{@current_user.first_name} has cancelled the challenge", "")
    render json: {message: "Successfully cancelled the challenge"}
  end
  
  def show_outgoing_challenges
    query = "SELECT c.id AS challenge_id, c.challengee_id AS challengee_id, first_name, matches_won, matches_lost, points, rating, number_ratings, fb_id, last_name, c.created_at AS created_at FROM ((SELECT id, challengee_id, created_at FROM challenges WHERE challenger_id = #{@current_user.id}) AS c INNER JOIN users on users.id = c.challengee_id)"
    results = Challenge.find_by_sql(query)
    render json: {results: results}
  end
  
  def show_incoming_challenges
    query = "SELECT c.id AS challenge_id, c.challenger_id AS challenger_id, first_name, matches_won, matches_lost, points, rating, number_ratings, fb_id, last_name, c.created_at AS created_at FROM ((SELECT id, challenger_id, created_at FROM challenges WHERE challengee_id = #{@current_user.id}) AS c INNER JOIN users on users.id = c.challenger_id)"
    results = Challenge.find_by_sql(query)
    render json: {results: results}
  end
  
private
    def login?
      unless @current_user
        render json: {errors: "Please log in"}, :status => 800
      end
    end
    
    def accept_game(challenger)
      if Game.find_by_player1id_and_player2id(challenger.id, @current_user.id) #check if current user has initiated the game before
        render json: {errors: "There is already an ongoing game between you and your friend"}
        return false
      end
      ongoing_game = @current_user.accepting_games.build(player2id: challenger.id)
      unless ongoing_game.save
        render json: {errors: "There is already an ongoing game between you and your friend"}
        return false
      end
      return ongoing_game
      #send out notification's for challenger to prompt him to set a mystery friend
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
