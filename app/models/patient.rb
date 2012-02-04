class Patient < ActiveRecord::Base
  has_many :log_entries
  has_one :convo_handler
end
