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
        render json: {"error": true, "msg": "slot is alredy there"}
        return
      end
      render json: {"error": true, "msg": "slot created"}
    rescue Exception => e
      render json: {"error": true, "msg": e.to_s}
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
            render json: {"error": true, "msg": "slot booked"}
          else
            render json: {"error": true, "msg": "slot is already booked"}  
          end
        else
          render json: {"error": true, "msg": "slot doesn't exists"}
        end
      else
        render json: {"error": true, "msg": "user doesn't exists"}
      end
    rescue Exception => e
      render json: {"error": true, "msg": e.to_s}
    end
  end

  def get_slots is_available = nil
    begin
      if !is_user_exists? params[:email]
        render json: {"error": true, "msg": "user doesn't exists"}
        return
      end
      calendar = @user.calendar.year.find_by(:name => params[:year])
      if calendar.nil?
        render json: {"error": true, "msg": "no available slots for this date"}
        return
      end
      calendar = calendar.month.find_by(:name => params[:month])
      if calendar.nil?
        render json: {"error": true, "msg": "no available slots for this date"}
        return
      end
      calendar = calendar.day.find_by(:name => params[:day])
      if calendar.nil?
        render json: {"error": true, "msg": "no available slots for this date"}
        return
      end
      if is_available.nil?
        slots = calendar.slot.all
      else
        slots = calendar.slot.where(:is_available => is_available)
      end
      render json: {"error": true, "data": slots}
    rescue Exception => e
      render json: {"error": true, "msg": e.to_s}
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
      puts @calendar.month
      @calendar = @calendar.month.find_by(:name => params[:month])
      puts 'calendar', @calendar
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
      puts e
      return false
    end
  end

  def is_slot_available?
    return @calendar.is_available
  end

end
