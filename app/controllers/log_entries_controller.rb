class LogEntriesController < ApplicationController
 
  def index
    @patient = Patient.find(params[:patient_id])
    @log_entries = @patient.log_entries
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
    @patient = Patient.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
  end

  def new
    @patient = Patient.find(params[:patient_id])
    @log_entry = LogEntry.new
  end

  def edit
    @patient = Patient.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
  end

  def create
    @patient = Patient.find(params[:patient_id])
    @log_entry = @patient.log_entries.create(params[:log_entry])
    redirect_to patient_log_entries_path(@patient)
  end

  def update
    @patient = Patient.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])

    respond_to do |format|
      if @log_entry.update_attributes(params[:log_entry])
        format.html { redirect_to patient_log_entries_path(@patient), notice: 'Log entry was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @log_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @patient = Patient.find(params[:patient_id])
    @log_entry = @patient.log_entries.find(params[:id])
    @log_entry.destroy
    redirect_to patient_log_entries_path(@patient)
  end
  
  
end
