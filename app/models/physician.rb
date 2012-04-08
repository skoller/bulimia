class Physician < ActiveRecord::Base
    attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :state, :specialty, :arch_id, :archive
    has_secure_password
    
    validates_presence_of :first_name, :last_name, :state, :specialty, :on => :update
    validates_presence_of :password, :on => :create
    validates_length_of :password, :minimum => 6, :allow_blank => false
    validates_confirmation_of :password, :on => :create 
    validates_presence_of :email
    validates_uniqueness_of :email
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    
    has_many :patients
    
    
    
    def full_name
      self.first_name + " " + self.last_name
    end
    
    
end
