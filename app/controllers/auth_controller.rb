class AuthController < ApplicationController
  before_action :current_user
  
  private  
    # Based on the user_id inside the token payload, find the user.
    def current_user
      if decoded_auth_token
        @current_user ||= User.find(decoded_auth_token[0]["id"])
        return
      end
      @current_user = nil
    end
  
    def authenticate_request
      if auth_token_expired?
        render json: { error: 'Auth token is expired' }, status: 419 # unofficial timeout status code
      elsif !@current_user
        render json: { error: 'You are not authorized to view this page.' }, status: :unauthorized
      end
    end
  
    def decoded_auth_token
      if http_auth_header_content.nil?
        @decoded_auth_token = nil
      else
        begin
          @decoded_auth_token ||= JWT.decode(http_auth_header_content, Rails.application.secrets.secret_key_base)
        rescue JWT::DecodeError
         render json: { errors: "Bad token." }, status: :unauthorized
         return
        end
      end
    end
  
    def auth_token_expired?
      decoded_auth_token && decoded_auth_token.expired?
    end
  
    # JWT's are stored in the Authorization header using this format:
    # Bearer somerandomstring.encoded-payload.anotherrandomstring
    def http_auth_header_content
      return @http_auth_header_content if defined? @http_auth_header_content
      @http_auth_header_content = begin
        if request.headers['Authorization'].present?
          request.headers['Authorization'].split(' ').last
        else
          nil
        end
      end
    end
end