class ConvoHandler < ActiveRecord::Base
  belongs_to :patient
  belongs_to :log_entry
  
  def drop_it_like_its_hot
    self.destroy
  end
end
