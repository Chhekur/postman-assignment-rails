class ApplicationController < ActionController::Base
  def hello
    render json: {"error": false, "msg": "Hi"}
  end
end
