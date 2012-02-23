class PatientsController < ApplicationController

  before_filter :authenticate_user

  def index
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])
      @pt = @ph.patients.where(:archive => nil).all
      @patients = @pt.sort_by { |pt| pt.last_name.downcase }
      @physician_or_admin_view = true
    else
      patient_restriction
    end
  end
  
  def archive
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])
      @patient = Patient.find(params[:id])
      @patient.activity_history = @patient.activity_history + "  >>>>>> Archived by #{@ph.email} on #{DateTime.now.to_time.strftime('%c')}"
      @patient.archive = true
      @patient.phone_number = ""
      if @patient.save(:validate => false)
        redirect_to pt_archive_index_path(:physician_id => @ph.id)
      else
        redirect_to physician_patients_path(@ph)
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
        @patient.activity_history = "*****Account created by #{@ph.email} on #{DateTime.now.to_time.strftime('%c')}"
        @patient.signup_status = "new"
        @patient.start_code = rand(999999).to_s.center(6, rand(9).to_s)
        @password_random_suffix = rand(999999).to_s.center(6, rand(9).to_s)
        if @patient.save
          session[:patient_start] = @patient.id
          redirect_to sms_handler_path
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
        @patient.signup_status = "returning"
        @patient.save(:validate => false)

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
        @patient.signup_status = "returning"
        @patient.save(:validate => false)
        
        if @patient.update_attributes(params[:patient])
          redirect_to physician_patient_path(@ph, @patient), :notice => "The patient's password was successfully reset"
        else
          render :action =>"admin_pt_password_edit"
        end
      else
        redirect_to home_page_path
      end
    end
    
    def patient_welcome
      @pt = Patient.find(params[:patient_id])
      @ph = Physician.find(@pt.physician_id)
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
        @patient.signup_status = "returning"
        @patient.save(:validate => false)
        if @patient.update_attributes(params[:patient])
          redirect_to pt_show_path(params[:patient_id])
        else
          render :action => "patient_edit_limited"
        end
      else
        patient_restriction
      end
    end
    


  end
