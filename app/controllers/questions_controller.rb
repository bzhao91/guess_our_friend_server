class QuestionsController < AuthController
    protect_from_forgery
    skip_before_action :verify_authenticity_token
    before_action :login?
    before_action :set_game
    before_action :set_active_user
    
    #TODO: STILL HAS A LOT TO DO TO CLEAN THE MESS 
    #TODO: need to handle incorrect guess and finish guess function
    
    def create
        if params[:content].blank?
            render json: {errors: "Invalid question"}, :status => 812 and return
        end
       
        if @game.lock == false && @game.questions_left > 0 && @active_user_id == @current_user.id
            question = Question.new(
            content: params[:content],
            user_id: @current_user.id,
            game_id: @game.id
        )
            render json: question.to_json and return
            question.save
            #send out the question to the opponent including id
            @game.update_attribute(:lock, true) #lock the game
            send_gcm_message(@opponent.gcm_id, "#{@current_user.first_name}'s Asked", params[:content])
            render json: {message: "Successfully sent the question"} and return
        end
        
        if @active_user_id != @current_user.id
            render json: { errors: "You need to answer your opponent's question before proceeding"}, :status => 851 and return
        end
        
        if @game.lock == true
            render json: { errors: "Please wait for your previous question to be answered"}, :status => 852 and return
        end
        
        if @game.questions_left == 0
            render json: { errors: "You do not have any questions left"}, :status => 853 and return
        end
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
         
        if @game.lock == false
            if @current_user == @active_user_id
                render json: {errors: "Please ask a question and wait for your opponent to answer"}, :status => 813 and return
            else
                render json: {errors: "Please wait for your opponent to ask a question first"}, :status => 813
            end
        end
        
        if question.user_id == @current_user.id
            render json: {errors: "You can not answer your own question"}, :status => 812 and return
        end
        
        @game.update_attribute(:questions_left, @game.questions_left-1)
        @game.update_attribute(:lock, false)
        question.update_attribute(:answer, a)
        send_gcm_message(@opponent.gcm_id, "#{@current_user.first} Answered", question.to_json)
        #send answer to opponent
        render json: {message: "Successfully answered the question"}
    end
    
    def guess
        if @game.lock == true
            if @current_user.id == @active_user_id
                render json: {errors: "Please wait for your question to be answered"}, :status => 814 and return
            else
                render json: {errors: "Invalid move, please answer the pending question"}, :status => 815 and return
            end
        end
        #game is unlocked
          
        if @current_user.id != @active_user_id
            render json: { errors: "Invalid move, please wait until your turn"}, :status => 814 and return
        end
        
        if @game.questions_left > 0
            render json: {errors: "Please answer your remaining questions before taking a guess"}, :status => 816 and return
        end
        
        if params[:guess_id] == -1
            @game.update_attribute(:questions_left, 1)
            @game.update_attribute(:active_move, !@game.active_move)
            render json: {message: "Player has given up the guess opportunity"} and return
        end
      
        #take the guess, check if it's correct answer
        opponent_mystery_id = @current_user.id == @game.player1id ? @game.mystery_friend2 : mystery_friend1
        guess_friend = FriendPool.find_by_id(params[:guess_id])
        
        if guess_friend.blank?
            render json: {errors: "Invalid guess"}, :status => 815 and return
        end
        
        if guess_friend.game_id != @game.id || guess_friend.user_id != @active_user_id
            render json: {errors: "Invalid guess"}, :status => 815 and return
        end
        
        if params[:guess_id] == opponent_mystery_id
            
            send_gcm_message(@opponent.gcm_id, "#{@current_user.first_name} Made the Guess!", "#{@current_user.first_name} guessed #{guess_friend.first_name} #{guess_friend.last_name}, #{@current_user.first_name} wins!")
            #win the game
            #update the stats
            #send failure message to the opponent
            render json: {message: "You have won the game"} and return
        else
            #the other person gets two chances
            @game.update_attribute(:questions_left, 2)
            @game.update_attribute(:active_move, !@game.active_move)
            #send the reward message to the opponent
            send_gcm_message(@opponent.gcm_id, "#{@current_user.first_name} Made the Guess!", "#{@current_user.first_name} guessed #{guess_friend.first_name} #{guess_friend.last_name} #{@current_user.first_name} guessed incorrectly, you are rewarded with an extra question!")
            render json: {message: "Your guess is wrong. Your opponent will be rewarded with two questions"}
        end
    end  
    
    
private   
    def login?
      unless @current_user
        render json: {errors: "Please log in"}, :status => 800
      end
    end
    
    def set_active_user
        @active_user_id = game.active_move == true ? @game.player1id : @game.player2id
    end
    
    def set_game
       
        @game = Game.find_by_id(params[:game_id])
        unless @game
            render json: {errors: "Game does not exist"}, :status => 810 and return
        end
        if @current_user.id != @game.player1id && @current_user.id != @game.player2id
            render json: {errors: "Invalid game"}, :status => 811 and return
        end
        @opponent = @current_user.id == @game.player1id ? User.find_by_id(@game.player2id) : User.find_by_id(@game.player1id)
      
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
