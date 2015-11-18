class QuestionsController < AuthController
    protect_from_forgery
    skip_before_action :verify_authenticity_token
    before_action :login?
    before_action :set_game
    before_action :set_active_user
    
    #TODO: STILL HAS A LOT TO DO TO CLEAN THE MESS 
    #TODO: need to handle incorrect guess and finish guess function
    
    def create
        #current user has that game
        if @game.lock == true
            if @active_user_id == @current_user.id
                render json: { errors: "You need to answer your opponent's question before proceeding"} and return
            else
                render json: { errors: "Please wait for your previous question to be answered"} and return
            end
        end
        if @active_user_id != @current_user.id
            render json: {errors: "Invalid operation"}, :status => 811 and return
        end
        if params[:content].blank?
            render json: {errors: "Invalid question"}, :status => 812 and return
        end
        question = Question.new(
            content: params[:content],
            user_id: @current_user.id,
            game_id: @game.id
        )
        question.save
        @game.update_attribute(:active_move, !game.active_move)
        render json: {message: "Successfully sent the question"}
    end
    
    def answer
        a = params[:answer]
        if a != 0 && a != 1 && a != 2 #0 as no, 1 as yes, 2 as dont know
            render json: {errors: "Invalid answer"}
        end
        question = Question.find_by_id(params[:question_id])
        if questions.game_id != @game.id
            render json: {errors: "Invalid game"}, :status => 811 and return
        end
        if question.user_id == @current_user.id
            render json: {errors: "You can not answer your own question"}, :status => 812 and return
        end
        question.update_attribute(:answer, a)
       
        #send answer to opponent
        render json: {message: "Successfully answered the question"}
    end
    
    def guess
        if @current_user.id == @active_user_id
            render json: { errors: "Please ask a question before take a guess"}, :status => 813 and return
        end
        if @game.locked == false
            render json: { errors: "You have missed your opportunity to take the guess"}, :status => 814 and return
        end
        #take the guess, check if it's correct answer
        
        @game.update_attribute(:locked, false)
    end  
    
    
private   
    def login?
      unless @current_user
        render json: {errors: "Please log in"}, :status => 800
      end
    end
    
    def set_active_user
        @active_user_id = game.active_move == true ? player1id : player2id
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
