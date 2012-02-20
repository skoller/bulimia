class LogEntry < ActiveRecord::Base
  belongs_to :patient
  has_one :convo_handler

  def drop_it
    self.destroy
  end

  def day_web_display
    if self.date
      day = self.date.to_time.strftime('%d').to_i.to_s
      return (day + self.date.to_time.strftime('%a %b %d %Y'))
    end
  end

  def time_web_display
    if self.date
      hour = self.date.to_time.strftime('%I').to_i.to_s
      return (hour + self.date.to_time.strftime(':%M%p'))
    end
  end


end
