class CalendarController < ApplicationController
  include CalendarHelper

  skip_before_action :verify_authenticity_token
  before_action :authorize_request

  def create_slot
    return if !validate_params_for_create_slot? params
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
    return if !validate_params_for_book_slot? params
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
    return if !validate_params_for_get_slot? params
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

  def delete_slot
    return if !validate_params_for_delete_slot? params
    if is_slot_exists?
      begin
        @calendar.delete
        render json: {"error": false, "msg": "slot deleted"}, status: 200
      rescue Exception => e
        render json: {"error": true, "msg": e.to_s}, status: 400
      end
    else
      render json: {"error": true, "msg": "slot doesn't exists"}, status: 400
    end
  end

  def update_slot
    return if !validate_params_for_update_slot? params
    if is_slot_exists?
      start_time = params[:start_time]
      end_time = params[:end_time]
      params[:start_time] = params[:new_start_time]
      params[:end_time] = params[:new_end_time]
      if !is_slot_exists?
        @calendar = @calendar.slot.find_by(:start_time => start_time, :end_time => end_time)
        @calendar[:start_time] = params[:start_time]
        @calendar[:end_time] = params[:end_time]
        render json: {"error": false, "msg": "slot updated"}, status: 200
        begin
          @calendar.save!
        rescue Exception => e
          render json: {"error": true, "msg": e.to_s}, status: 400
        end
      else
        render json: {"error": false, "msg": "new slot already exists"}, status: 400
      end
    else
      render json: {"error": true, "msg": "slot doesn't exists"}, status: 400
    end
  end

  def get_available_slots
    return if !validate_params_for_get_slot? params
    get_slots(true)
  end

  def get_booked_slots
    return if !validate_params_for_get_slot? params
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
      @user = @current_user if @user.nil?
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
      temp = @calendar.slot.find_by(:start_time => params[:start_time], :end_time => params[:end_time])
      if temp.nil?
        return false
      end
      @calendar = temp
      return true
    rescue Exception => e
      return false
    end
  end

  def is_slot_available?
    return @calendar.is_available
  end

end
