class Patient < ActiveRecord::Base
  has_many :log_entries
  has_one :convo_handler

  def base_date
  	unless @base_date
    	@base_date = @patient.log_entries.first.created_at.change(:hour => 8)
  	end
	end

	def determine_log_entry_day_index(log_entry)
  	return (self.base_date - log_entry.created_at.change(:hour => 8)).to_i
	end
end
