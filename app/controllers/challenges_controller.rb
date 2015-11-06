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
      render json: {errors: "Your opponent has already challenged"}, :status => 804 and return
    end
    challenge = @current_user.sending_challenges.create(challengee_id: challengee.id)
    if challenge.save
      render json: {message: "Successfully sent out challenge!"}
    else
      render json: {errors: challenge.errors}, :status => 805
    end
  end
  
  def destroy
    
  end
  
  def show_outgoing_challenges
    query = "SELECT c.id AS challenge_id, c.challengee_id AS challengee_id, first_name, matches_won, matches_lost, points, rating, number_ratings, fb_id, last_name, c.created_at AS created_at FROM ((SELECT id, challengee_id, created_at FROM challenges WHERE challenger_id = #{@current_user.id}) AS c INNER JOIN users on users.id = c.challengee_id)"
    results = Challenge.find_by_sql(query)
    render json: {results: results}
  end
  
  def show_incoming_challenges
    render json: {results: @current_user.challenged_bys}
  end
  
private
    def login?
      unless @current_user
        render json: {errors: "Please log in"}, :status => 800
      end
    end
end
