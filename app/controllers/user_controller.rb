class UserController < ApplicationController
  skip_before_action :verify_authenticity_token
  def signup
    @user = User.create(:name => params[:name], :email => params[:email], :password => params[:password])
    if @user.errors.empty?
      render json: {'error': false, "msg": "success"}
    else 
      render json: {'error': true, 'msg': @user.errors}
    end
  end

  def login
    @user = User.find_by(:email => params[:email])
    if @user.nil?
      render json: {"error": true, "msg": "invalid details"}
    else
      if @user.authenticate(params[:password])
        render json: {"error": false, "msg": "success"}
      else
        render json: {"error": true, "msg": "invalid details"}
      end
    end
  end
end
