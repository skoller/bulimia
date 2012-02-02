class Patient < ActiveRecord::Base
  has_many :log_entries
end
