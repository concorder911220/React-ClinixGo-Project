class Api::V1::UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def create
    @user = User.create(user_params)
    if @user.save
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token:, message: 'User created' }, status: :created
    else
      render json: @user.errors.full_messages, status: :unprocessable_entity, message: 'Sorry! Something went wrong'
    end
  end

  def login
    @user = User.find_by(username: user_params[:username])
    if @user&.authenticate(user_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token:, message: 'User logged in successfully' }, status: :ok
    else
      render json: { errors: 'Invalid login credentials' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :password, :age, :gender, :email)
  end
end
