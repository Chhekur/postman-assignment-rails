class CalendarController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_action :authorize_request, except: [:singup, :login]

  def create_slot
    begin
      calendar = @current_user.calendar
      if calendar.year.find_by(:name => params[:year]).nil?
        calendar.year.create(:name => params[:year])
      end
      calendar = calendar.year.find_by(:name => params[:year])
      if calendar.month.find_by(:name => params[:month]).nil?
        calendar.month.create(:name => params[:year])
      end
      calendar = calendar.month.find_by(:name => params[:month])
      if calendar.day.find_by(:name => params[:day]).nil?
        calendar.day.create(:name => params[:day])
      end
      calendar = calendar.day.find_by(:name => params[:day])
      if calendar.slot.find_by(:start_time => params[:start_time], :end_time => params[:end_time]).nil?
        calendar.slot.create(:start_time => params[:start_time], :end_time => params[:end_time], :is_available => true)
      else
        render json: {"error": true, "msg": "slot is alredy there"}
        return
      end
      render json: {"error": true, "msg": "slot created"}
    rescue Exception => e
      render json: {"error": true, "msg": e.to_s}
    end
  end

  def book_slot
    
  end
end
