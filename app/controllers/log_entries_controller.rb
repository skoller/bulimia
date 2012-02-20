class LogEntriesController < ApplicationController
 
  before_filter :authenticate_user
  before_filter :restrict_access_to_relevant_pages
  
  def index
    if session[:physician_id]
      @physician_view = true
    elsif session[:patient_id]
      @patient_view = true
    end
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entries = @patient.log_entries.order('date DESC')
    respond_to do |format|
        format.html
        format.pdf do
          pdf = LogPdf.new(@patient)
          send_data pdf.render, filename: "#{@patient.last_name.capitalize}#{@patient.first_name.split(//)[0].capitalize}_#{Date.today}_EatingLog.pdf",
                                type: "application/pdf",
                                disposition: "inline"
                                
        end
    end
  end

  def show
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
  end

  def new
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.build
  end

  def edit
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
  end

  def create
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.build(params[:log_entry])
    if @log_entry.save
      redirect_to physician_patient_log_entry_path(@ph, @patient, @log_entry), notice: 'Log Entry was successfully created.'
    else
      render action:'new'
    end
  end

  def update
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
    
    if @log_entry.update_attributes(params[:log_entry])
      redirect_to physician_patient_log_entry_path(@ph, @patient, @log_entry), notice: 'Log entry was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @ph = Physician.find(params[:physician_id])
    @patient = @ph.patients.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
    @log_entry.destroy
    redirect_to physician_patient_log_entries_path(@ph, @patient)
  end
  
  
end
