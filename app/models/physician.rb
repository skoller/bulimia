class Physician < ActiveRecord::Base
    attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :state, :specialty, :arch_id, :archive
    has_secure_password
    validates_presence_of :password, :on => :create
    has_many :patients
    
    
    
    def full_name
      self.first_name + " " + self.last_name
    end
    
    
end
