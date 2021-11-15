class ApplicationController < ActionController::Base

    helper_method :current_user, :logged_in?

    def current_user 
        @current_user ||= User.find_by(session_token: session[:session_token])
    end
    
    def logged_in?
        !!current_user
    end

    def login(user)
        session[:session_token] = user.reset_session_token!
    end

    def require_logged_out
        redirect_to cats_url if logged_in?
    end

    def is_not_owner
        @cat = Cat.find(params[:id])
        unless @cat.owner == current_user
        redirect_to cats_url
        end
    end

end
