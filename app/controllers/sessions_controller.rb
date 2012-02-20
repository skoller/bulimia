class SessionsController < ApplicationController

  def new_physician_session
    session[:physician_id] = nil
  end

  def new_patient_session
    session[:patient_id] = nil 
  end

  def create_ph_session
    ph = Physician.find_by_email(params[:email])
    if (ph.email == 'dev@bvl.com') && ph.authenticate(params[:password])
      session[:physician_id] = ph.id
      redirect_to admin_path(ph), notice: "Welcome Administrator!"
    elsif (ph.email != 'dev@bvl.com') && ph.authenticate(params[:password]) && ph.state
      session[:physician_id] = ph.id
      redirect_to physician_patients_path(ph), notice: "Logged in!"
    elsif (ph.email != 'dev@bvl.com') && ph.authenticate(params[:password]) && ph.state == nil
      session[:physician_id] = ph.id
      redirect_to physician_additional_info_path(:id => ph.id)
    else
      render "new_physician_session", notice: "Invalid email or password"
    end
  end
  
  def new_patient_start_code_entry
  end
  
  def new_patient_code_verification
    @pt_phone_number = Patient.find_by_phone_number(params[:phone_number])
    @pt_code = Patient.find_by_start_code(params[:start_code])
    
    
    if @pt_code == @pt_phone_number
      session[:start] = @pt_code.id
      redirect_to new_patient_password_setup_path(:pt_id => @pt_code.id)
    elsif @pt_code && !@pt_phone_number
      render 'new_patient_start_code_entry', :notice => "Bivola does not recognize the start code you provided."
    elsif !@pt_code && @pt_phone_number
      render 'new_patient_start_code_entry', :notice => "Bivola does not recognize the phone number you provided."  
    else
      render 'new_patient_start_code_entry', :notice => "Bivola does not recognize the phone number or start code you provided."  
    end
      
  end
  
  def new_patient_password_setup
    @patient = Patient.find(params[:pt_id])
  end
  
  def password_set
    @patient = Patient.find_by_phone_number(params[:phone_number])
    if (session[:start]).to_s == @patinent.id
    
      if @patient.update_attributes(params[:patient])
        redirect_to patient_matched_path(:phone_number => @patient.phone_number)
      else
        redirect_to new_patient_password_setup_path(:pt_id => @patient.id)
      end
      
    else
      redirect_to home_page_path
    end
  end
    

  def create_pt_session
    pt = Patient.find_by_phone_number(params[:phone_number])
    ph = Physician.find(pt.physician_id)
    if ph.id == nil && ph.arch_id
      render "doctor_deactivated"
      return false
    end
    if pt
      if pt.signup_status == "returning"
        if pt && pt.authenticate(params[:password])
          session[:patient_id] = pt.id
          redirect_to physician_patient_log_entries_path(ph, pt), notice: "Logged in!"
        else
          render "new_patient_session", :notice => "Invalid email or password"
        end
      elsif pt.signup_status == "new"
        session[:patient_id] = pt.id
        pt.signup_status = "returning"
        pt.save(:validate => false)
        redirect_to patient_welcome_path(:patient_id => pt.id)
      else
        redirect_to home_page_path
      end
    else
        redirect_to home_page_path
    end
  end

  def destroy_ph
    session[:physician_id] = nil
    redirect_to home_page_path, notice: "Logged out!"
  end

  def destroy_pt
    session[:patient_id] = nil
    redirect_to home_page_path, notice: "Logged out!"
  end

end