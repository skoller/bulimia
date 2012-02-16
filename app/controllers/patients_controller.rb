class PatientsController < ApplicationController
  
  before_filter :authenticate_physician
 
  def index
    @ph = Physician.find(params[:physician_id])
    @pt = @ph.patients
    @patients = @pt.sort_by { |pt| pt.last_name.downcase }
  end

  def show
    @ph = Physician.find(params[:physician_id])
    @patient = Patient.find(params[:id])
  end

  def new
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.build
  end

  def edit
    @patient = Patient.find(params[:id])
    @ph = Physician.find(params[:physician_id])
  end


  def create
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.build(params[:patient])

    if @patient.save
      redirect_to physician_patients_path(@ph), notice: 'Patient was successfully created.'
    else
      render action: "new"
    end
  end


  def update
    @ph = Physician.find(params[:physician_id])
    @patient = Patient.find(params[:id])
    
    if @patient.update_attributes(params[:patient])
      redirect_to physician_patient_path, notice: 'Patient was successfully updated.' 
    else
      render action: "edit"
    end
  end

 
  def destroy
    @patient = Patient.find(params[:id])
    @ph = Physician.find(params[:physician_id])
    @patient.destroy
    redirect_to physician_patients_url(@ph)
  end
  
  
  
end
