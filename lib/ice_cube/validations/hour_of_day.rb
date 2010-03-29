module HourOfDayValidation
  
  def self.included(base)
    base::SuggestionTypes << :hour_of_day
  end
  
  def hour_of_day(*hours)
    @hours_of_day ||= []
    hours.each do |hour| 
      raise ArgumentError.new('Argument must be a valid hour') unless hour < 24 && hour >= 0
      @hours_of_day << hour
    end
    self
  end
  
  def validate_hour_of_day(date)
    return true if !@hours_of_day || @hours_of_day.empty?
    @hours_of_day.include?(date.hour)
  end
  
  def closest_hour_of_day(date)
    return nil if !@hours_of_day || @hours_of_day.empty?
    # turn hours into hour of day
    # hour >= 24 should fall into the next day
    hours = @hours_of_day.map do |h|
      h > date.hour ? h - date.hour : 24 - date.hour + h
    end
    hours.compact!
    # go to the closest distance away, the start of that hour
    closest_hour = hours.min
    date + 60 * 60 * closest_hour
  end
  
end