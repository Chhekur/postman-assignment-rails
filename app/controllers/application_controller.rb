class ApplicationController < ActionController::Base
  def hello
    render json: {"error": false, "msg": "Hi"}, status: 200
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { "error": true,  "msg": "unauthorized access" }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { "error": true, "msg": "unauthorized access" }, status: :unauthorized
    end
  end
end
