class AdminController < ApplicationController
  
  before_filter :authenticate_admin
  
  def index
    @physicians = Physician.where(:archive => nil).all
    @admin_home = true
  end
  
  def archived_physicians
    @physicians_archive = Physician.where(:archive => true).all
  end
  
  def archived_patients
    @patients_arch = Patient.where(:archive => true).all
  end
  
  def active_patients
    @patients_act = Patient.where(:archive => nil).all
  end
  
end