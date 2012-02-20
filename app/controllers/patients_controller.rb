class PatientsController < ApplicationController

  before_filter :authenticate_user

  def index
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])
      @pt = @ph.patients.where(:archive => nil).all
      @patients = @pt.sort_by { |pt| pt.last_name.downcase }
    else
      patient_restriction
    end
  end
  
  def archive
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])
      @patient = Patient.find(params[:id])
      @patient.archive = true
      if @patient.save(:validate => false)
        redirect_to pt_archive_index_path(:physician_id => @ph.id)
      else
        redirect_to admin_path(@ph)
      end
    else
      patient_restriction
    end
  end
  
  def index_pt_archive
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])
      @pt = @ph.patients.where(:archive => true).all
      @patients = @pt.sort_by { |pt| pt.last_name.downcase }
    else
      patient_restriction
    end
  end

    def show
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @ph = Physician.find(params[:physician_id])
        @patient = Patient.find(params[:id])
      else
        patient_restriction
      end
    end

    def new
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @ph = Physician.find(params[:physician_id])
        @patient = @ph.patients.build
      else
        patient_restriction
      end
    end

    def edit
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @patient = Patient.find(params[:id])
        @ph = Physician.find(params[:physician_id])
      else
        patient_restriction
      end
    end

    def create
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @ph = Physician.find(params[:physician_id])
        @patient = @ph.patients.build(params[:patient])

        if @patient.save
          redirect_to physician_patients_path(@ph)
        else
          render :action => "new"
        end
      else
        patient_restriction
      end
    end

    def update
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @ph = Physician.find(params[:physician_id])
        @patient = Patient.find(params[:id])

        if @patient.update_attributes(params[:patient])
          redirect_to physician_patient_path
        else
          render :action =>"edit"
        end
      else
        patient_restriction
      end
    end


    def destroy
      if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
        @patient = Patient.find(params[:id])
        @ph = Physician.find(params[:physician_id])
        @patient.destroy
        redirect_to physician_patients_url(@ph)
      else
        patient_restriction
      end
    end
    
    def admin_pt_password_edit
      if session[:physician_id] == 1
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)  
      else
        redirect_to home_page_path
      end
    end
    
    def admin_pt_password_update
      if session[:physician_id] == 1
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)
        
        if @patient.update_attributes(params[:patient])
          redirect_to physician_patient_path(@ph, @patient), :notice => "The patient's password was successfully reset"
        else
          render :action =>"admin_pt_password_edit"
        end
      else
        redirect_to home_page_path
      end
    end
    
    
    

    ############# paitent-specific methods #######

    def patient_edit_limited
      if (session[:patient_id]).to_s && (params[:patient_id] == (session[:patient_id]).to_s)
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)
      else
        physician_restriction
      end
    end

    def patient_show_limited
      if (session[:patient_id]).to_s && ((params[:patient_id]) == (session[:patient_id]).to_s)
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)
      else
        physician_restriction
      end
    end

    def patient_update_limited
      if (session[:patient_id]).to_s && ((params[:patient_id]) == (session[:patient_id]).to_s)
        @patient = Patient.find(params[:patient_id])
        @ph = Physician.find(@patient.physician_id)
        if @patient.update_attributes(params[:patient])
          redirect_to pt_show_path(params[:patient_id])
        else
          render :action => "patient_edit_limited"
        end
      else
        patient_restriction
      end
    end
    
    def set_password_via_sms
      
    end


  end
