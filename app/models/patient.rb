class Patient < ActiveRecord::Base
  attr_accessible :phone_number, :password, :password_confirmation, :first_name, :last_name, :dob, :sex, :diagnosis, :archive
  has_secure_password
  validates_presence_of :password, :on => :create
  
  validates_presence_of :first_name, :last_name
  validates_presence_of :password, :on => :create
  validates_length_of :password, :minimum => 6, :allow_blank => false, :on => :create
  validates_confirmation_of :password, :on => :create 
  validates_presence_of :phone_number, :length => { :is => 10 }
  validates_presence_of :phone_number, :format => { :with => /^\d{10}$/, :message => "Must be 10 digits and contain no parathesis or dashes" }
  validates_uniqueness_of :phone_number
  validates_presence_of :sex, :on => :create
  validates_presence_of :dob, :on => :create, :format => { :with => /^(0[1-9]{1}|[12]{1}[0-9]{1}|3[01]{1}).{1}(0[1-9]{1}|1[0-2]{1}).{1}([12]{1}[0-9]{3})$/, :message => "MM-DD-YYYY format required" }
  validates_presence_of :diagnosis, :on => :create
  
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
