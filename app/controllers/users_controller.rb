class UsersController < ApplicationController
    before_action :authorized, only: [:auto_login]
    # Register
    def create
        @user = User.create(user_params)
        if @user.valid?
            token = encode_token({user_id: @user.id})
            render json: {user: @user,token:token}
        else
            render json: {error: "Invalid username or password"}
        end
    end

    # Login
    def login
        @user = User.find_by(username:params[:user][:username])

        # check if the user fin the username and check if the password is same to
        # the inputted password

        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id:@user.id})
            render json: {user: @user,token:token}
        else
            render json: {error: "Invalid username or password"}
        end
    end

    def auto_login
        render json: {user:@user}
    end



    private def user_params
        params.permit(:username,:password,:age)
    end

end
