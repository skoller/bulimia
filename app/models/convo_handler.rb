class ConvoHandler < ActiveRecord::Base
  belongs_to :patient
  belongs_to :log_entry
end
