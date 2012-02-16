class Physician < ActiveRecord::Base
    attr_accessible :email, :password, :password_confirmation
    has_secure_password
    validates_presence_of :password, :on => :create
    has_many :patients
end
