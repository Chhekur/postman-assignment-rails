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
        calendar.month.create(:name => params[:month])
      end
      calendar = calendar.month.find_by(:name => params[:month])
      if calendar.day.find_by(:name => params[:day]).nil?
        calendar.day.create(:name => params[:day])
      end
      calendar = calendar.day.find_by(:name => params[:day])
      if calendar.slot.find_by(:start_time => params[:start_time], :end_time => params[:end_time]).nil?
        calendar.slot.create(:start_time => params[:start_time], :end_time => params[:end_time], :is_available => true)
      else
        render json: {"error": true, "msg": "slot is alredy there"}, status: 400
        return
      end
      render json: {"error": false, "msg": "slot created"}, status: 200
    rescue Exception => e
      render json: {"error": true, "msg": e.to_s}, status: 400
    end
end

  def book_slot
    begin
      if is_user_exists? params[:email]
        if is_slot_exists?
          if is_slot_available?
            @calendar.is_available = false
            @calendar.user = @user.id
            @calendar.save!
            render json: {"error": false, "msg": "slot booked"}, status: 200
          else
            render json: {"error": true, "msg": "slot is already booked"}, status: 400
          end
        else
          render json: {"error": true, "msg": "slot doesn't exists"}, status: 400
        end
      else
        render json: {"error": true, "msg": "user doesn't exists"}, status: 400
      end
    rescue Exception => e
      render json: {"error": true, "msg": e.to_s}, status: 400
    end
  end

  def get_slots is_available = nil
    begin
      if !is_user_exists? params[:email]
        render json: {"error": true, "msg": "user doesn't exists"}, status: 400
        return
      end
      calendar = @user.calendar.year.find_by(:name => params[:year])
      if calendar.nil?
        render json: {"error": true, "msg": "no available slots for this date"}, status: 400
        return
      end
      calendar = calendar.month.find_by(:name => params[:month])
      if calendar.nil?
        render json: {"error": true, "msg": "no available slots for this date"}, status: 400
        return
      end
      calendar = calendar.day.find_by(:name => params[:day])
      if calendar.nil?
        render json: {"error": true, "msg": "no available slots for this date"}, status: 400
        return
      end
      if is_available.nil?
        slots = calendar.slot.all
      else
        slots = calendar.slot.where(:is_available => is_available)
      end
      render json: {"error": false, "data": slots}, status: 200
    rescue Exception => e
      render json: {"error": true, "msg": e.to_s}, status: 400
    end
  end

  def get_available_slots
    get_slots(true)
  end

  def get_booked_slots
    get_slots(false) 
  end

  private

  def is_user_exists? email
    @user = User.find_by(:email => email)
    if @user.nil?
      return false
    end
    return true
  end

  def is_slot_exists?
    begin
      @calendar = @user.calendar.year.find_by(:name => params[:year])
      if @calendar.nil?
        return false
      end
      @calendar = @calendar.month.find_by(:name => params[:month])
      if @calendar.nil?
        return false
      end
      @calendar = @calendar.day.find_by(:name => params[:day])
      if @calendar.nil?
        return false
      end
      @calendar = @calendar.slot.find_by(:start_time => params[:start_time], :end_time => params[:end_time])
      if @calendar.nil?
        return false
      end
      return true
    rescue Exception => e
      return false
    end
  end

  def is_slot_available?
    return @calendar.is_available
  end

end
