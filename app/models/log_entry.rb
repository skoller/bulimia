class LogEntry < ActiveRecord::Base
  belongs_to :patient
  has_one :convo_handler
  
  def drop_it
    self.destroy
  end
end
