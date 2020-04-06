class UserController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :authorize_request, except: [:signup, :login]

  def signup
    @user = User.create(:name => params[:name], :email => params[:email], :password => params[:password])
    if @user.errors.empty?
      @user.calendar = Calendar.create()
      render json: {'error': false, "msg": "success"}, status: 200
    else 
      render json: {'error': true, 'msg': @user.errors}, status: 400
    end
  end

  def login
    if params[:email].nil? or params[:password].nil?
      render json: {"error": true, "msg": "missing parameters"}, status: 400
      return
    end
    @user = User.find_by(:email => params[:email])
    if @user.nil?
      render json: {"error": true, "msg": "invalid details"}, status: 400
    else
      if @user.authenticate(params[:password])
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        render json: {"error": false, "msg": "success", "token": token, "exp": time.strftime("%m-%d-%Y %H:%M")}, status: 200
      else
        render json: {"error": true, "msg": "invalid details"}, status: 400
      end
    end
  end
end
