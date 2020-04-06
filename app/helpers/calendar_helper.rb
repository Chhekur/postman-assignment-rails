module CalendarHelper

  def validate_params_for_create_slot? params
    if validate_general_params? or validate_slot?
      return false
    end
    return true
  end

  def validate_params_for_book_slot? params
    if validate_general_params? or validate_slot? or validate_email?
      return false
    end
    return true
  end

  def validate_params_for_get_slot? params
    if validate_general_params? or validate_email?
      return false
    end
    return true
  end

  def validate_params_for_delete_slot? params
    if validate_general_params? or validate_slot?
      return false
    end
    return true
  end

  def validate_params_for_update_slot? params
    if validate_general_params? or validate_slot?
      params[:start_time] = params[:new_start_time]
      params[:end_time] = params[:new_end_time]
      if validate_slot?
        return false
      end
      return false
    end
    return true
  end

  private

  def validate_general_params?
    if params[:year].nil? or params[:month].nil? or params[:day].nil?
      render json: {"error": true, "msg": "missing parameters"}, status: 400
      return true
    end
    begin
      year = params[:year].to_i
      if year < 1000 or year > 9999
        render json: {"error": true, "msg": "invalid year"}, status: 400
        return true
      end
    rescue Exception => e
      render json: {"error": true, "msg": "invalid year"}, status: 400
      return true
    end
    begin
      month = params[:month].to_i
      if month < 1 or month > 12
        render json: {"error": true, "msg": "invalid month"}, status: 400
        return true
      end
    rescue Exception => e
      render json: {"error": true, "msg": "invalid month"}, status: 400
      return true
    end
    begin
      day = params[:day].to_i
      if day < 1 or day > 31
        render json: {"error": true, "msg": "invalid day"}, status: 400
        return true
      end
    rescue Exception => e
      render json: {"error": true, "msg": "invalid day"}, status: 400
      return true
    end
    return false
  end

  def validate_slot?
    if params[:start_time].nil? or params[:end_time].nil?
      render json: {"error": true, "msg": "missing parameters"}, status: 400
      return true
    end
    begin
      start_time = params[:start_time].to_i
      if start_time < 1 or start_time > 24
        render json: {"error": true, "msg": "invalid start time"}, status: 400
        return true
      end
    rescue Exception => e
      render json: {"error": true, "msg": "invalid start time"}, status: 400
      return true
    end
    begin
      end_time = params[:end_time].to_i
      if end_time < 1 or end_time > 24
        render json: {"error": true, "msg": "invalid end time"}, status: 400
        return true
      end
    rescue Exception => e
      render json: {"error": true, "msg": "invalid end time"}, status: 400
      return true
    end
    return false
  end

  def validate_email?
    if params[:email].nil?
      render json: {"error": true, "msg": "missing parameters"}, status: 400
      return true
    end
    return false
  end
end
