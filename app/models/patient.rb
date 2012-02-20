class Patient < ActiveRecord::Base
  attr_accessible :phone_number, :password, :password_confirmation, :first_name, :last_name, :dob, :sex, :diagnosis, :archive
  has_secure_password
  validates_presence_of :password, :on => :create

  has_many :log_entries
  has_one :convo_handler
  has_one :physician

  def base_date
    unless @base_date
      @base_date = self.log_entries.first.created_at.change(:hour => 8)
    end
  end

  def determine_log_entry_day_index(log_entry)
    return (self.base_date - log_entry.date.change(:hour => 8)).to_i + 1
  end

  def last_name_first
    if self.first_name && self.last_name
      self.last_name + ", " + self.first_name
    end
  end

end
