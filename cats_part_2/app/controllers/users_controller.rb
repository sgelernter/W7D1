class UsersController < ApplicationController

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(user_params)
        if @user.save!
            login(@user)
            redirect_to cats_url
        else
            render :new
        end
    end

    private

    def user_params
        params[:user].permit(:username, :password, :session_token)
    end

end