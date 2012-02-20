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
  
  def reactivate_and_unarchive_patient
    @patient = Patient.find(params[:patient_id])
    @patient.archive = nil
    @patient.activity_history = @patient.activity_history + "  >>>>>> Reactivated (billing started) and unarchived by Admin on #{DateTime.now.to_time.strftime('%c')}"
    @patient.save(:validate => false)
    redirect_to active_patients_path
  end
  
  def deactivate_and_archive_patient
    @patient = Patient.find(params[:patient_id])
    @patient.archive = true
    @patient.activity_history = @patient.activity_history + "  >>>>>> Deactivated (billing stopped) and archived by Admin on #{DateTime.now.to_time.strftime('%c')}"
    @patient.save(:validate => false)
    redirect_to archived_patients_path
  end
  
  def archive_a_physician
    @ph = Physician.find(params[:physician_id])
    x = @ph.patients
    x.each do |pt|
      pt.doctor_status = "deactivated"
      pt.save(:validate => false)
    end
    @ph.archive = true
    @ph.arch_id = @ph.id.to_i - (2 * @ph.id.to_i)
    @ph.save(:validate => false) 
    @phys = (session[:physician_id]).to_s
    redirect_to archived_physicians_path(@phys) 
  end
  
  def unarchive_a_physician
    @ph = Physician.find(params[:physician_id])
    x = @ph.patients
    x.each do |pt|
      pt.doctor_status = "Active"
      pt.save(:validate => false)
    end
    @ph.archive = nil
    @ph.arch_id = nil
    @ph.save(:validate => false)
    @phys = (session[:physician_id]).to_s
    redirect_to admin_path(@phys) 
  end
  
end