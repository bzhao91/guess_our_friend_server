class ChallengesController < AuthController
  protect_from_forgery
  skip_before_action :verify_authenticity_token
  before_action :login?
  def create
    challengee = User.find(params[:challengee_id])
    unless challengee
      render json: {errors: "Opponent does not exist"}, :status => 802
      return
    end
    unless Friendship.find_by_user_id_and_friend_id(@current_user.id, challengee.id)
      render json: {errors: "Opponent is not your friend"}, :status => 803 and return
    end
      #the person you are challenging has already challenged you
    if Challenge.find_by_challenger_id_and_challengee_id(challengee.id, @current_user.id)
      render json: {errors: "Your opponent has already challenged you"}, :status => 804 and return
    end
    challenge = @current_user.sending_challenges.build(challengee_id: challengee.id)
    #render json: challenge and return 
    if challenge.save
      render json: {message: "Successfully sent out challenge!"}
    else
      render json: {errors: challenge.errors}, :status => 805
    end
  end
  
  def challengee_respond
    #two ways
    accept = params[:accept]
    challenger = User.find_by_id(params[:challenger_id])
    unless challenger
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    challenge = Challenge.find_by_id(params[:challenge_id])
    unless challenge
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    if challenge.challengee_id.to_i != @current_user.id || challenge.challenger_id.to_i != challenger.id
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    if accept == true
      #Game create
     
    else
      #send out decline message
      
    end
    challenge.destroy
    render json: {message: "Successfully #{accept == true ? 'accepted' : 'rejected'} the challenge"}
  end
  
  def challenger_respond
    challengee = User.find(params[:challengee_id])
    unless challengee
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    challenge = Challenge.find(params[:challenge_id])
    unless challenge
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    if challenge.challengee_id.to_i != challengee.id || challenge.challenger_id.to_i != @current_user.id
      render json: {errors: "Challenge does not exist"}, :status => 806 and return
    end
    challenge.destroy
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
end
