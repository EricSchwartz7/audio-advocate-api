module Api::V1
  class UsersController < ApplicationController

    def index
      @users = User.all
      render json: @users
    end

    def create
      user = User.new(user_params)
      if params[:password] == params[:password_confirmation]
        user.password = params[:password]
        if user.save
          jwt = Auth.encrypt({user: user.id}) # uses our encrypt method to return an encrypted user token
          render json: {jwt: jwt} # sends token to react action
        else
          render json: {:errors=>
           [{:detail=>"incorrect email or password",
             :source=>{:pointer=>"user/err_type"}}
           ]}, status: 404
        end
      else
        render json: {:errors=>
         [{:detail=>"failed password verification",
           :source=>{:pointer=>"user/err_type"}}
         ]}, status: 404
      end
    end

    def login
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        jwt = Auth.encrypt({user: user.id})  # issue new jwt token
        render json: {jwt: jwt, username: user.username}  # render json with token and sends token to react action
      end
    end

    def active
      if active_user
        username = active_user.username
        render json: {username: username}
      end
    end

    private

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end

  end
end
