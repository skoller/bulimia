class SessionsController < ApplicationController

  def new_physician_session
    session[:physician_id] = nil
  end

  def new_patient_session
    session[:patient_id] = nil
    session[:first_login_restriction] = true 
  end

  def create_ph_session
    ph = Physician.where(:email => (params[:email])).first
    unless ph == nil
      if (ph.email == 'dev@bvl.com') && ph.authenticate(params[:password])
        session[:physician_id] = 1
        redirect_to admin_path(ph)
        return false
      elsif (ph.email != 'dev@bvl.com') && ph.authenticate(params[:password]) && ph.state
        session[:physician_id] = ph.id
        redirect_to physician_patients_path(ph)
        return false
      elsif (ph.email != 'dev@bvl.com') && ph.authenticate(params[:password]) && ph.state == nil
        session[:physician_id] = ph.id
        redirect_to physician_additional_info_path(:id => ph.id)
        return false
      elsif !ph.authenticate(params[:password])
        render "new_physician_session" 
        return false
      end
    else
      render "new_physician_session"
      return false
    end
  end

  def new_patient_start_code_entry
  end

  def new_patient_code_verification
    pt_phone_number = Patient.where(:phone_number => params[:phone_number]).first
    pt_code = Patient.where(:start_code => params[:start_code]).first
    unless pt_phone_number == nil || pt_code == nil
      if pt_phone_number.signup_status == "returning"
        render 'new_patient_session'
        return false
      end
      if pt_code.phone_number == pt_phone_number.phone_number
        session[:start] = pt_code.id
        redirect_to new_patient_password_setup_path(:pt_id => pt_code.id)
        return false
      elsif pt_code.phone_number && !pt_phone_number.phone_number
        render 'new_patient_start_code_entry', flash.now.alert = "Bivola does not recognize the start code you provided."
        return false
      elsif !pt_code.phone_number && pt_phone_number.phone_number
        render 'new_patient_start_code_entry', flash.now.alert = "Bivola does not recognize the phone number you provided."  
        return false
      end
    else
      render 'new_patient_start_code_entry', flash.now.alert = "Bivola does not recognize the phone number or start code you provided."  
      return false
    end

  end

  def new_patient_password_setup
    @patient = Patient.find(params[:pt_id])
  end

  def password_set
    @patient = Patient.find(params[:pt_id])
    if (session[:start]).to_s == @patient.id.to_s
      ############ CURRENTLY @patient evals to nil
      if @patient.update_attributes(params[:patient])
        session[:start] = nil
        redirect_to patient_matched_path(:phone_number => @patient.phone_number)
        return false
      else
        redirect_to new_patient_password_setup_path(:pt_id => @patient.id)
        return false
      end

    else
      redirect_to home_page_path
      return false
    end
  end


  def create_pt_session
    pt = Patient.where(:phone_number => params[:phone_number]).first
    if pt
       ph = Physician.find(pt.physician_id)
       if ph.id == nil && ph.arch_id
         render "doctor_deactivated"
         return false
       end
    end
    
    if pt
      if pt.signup_status == "returning"
        if pt && pt.authenticate(params[:password])
          session[:patient_id] = pt.id
          redirect_to physician_patient_log_entries_path(ph, pt), notice: "Logged in!"
          return false
        else
          render "new_patient_session", :notice => "Invalid email or password"
          return false
        end
      elsif pt.signup_status == "new"
        if session[:first_login_restriction]
          session[:first_login_restriction] = nil
          redirect_to new_patient_start_code_entry_path, :notice => "Because you are a new patient, please sign up here." 
          return false
        else
          session[:patient_id] = pt.id
          pt.signup_status = "returning"
          pt.save(:validate => false)
          session[:start] = nil
          redirect_to patient_welcome_path(:patient_id => pt.id)
          return false
        end
      else
        redirect_to home_page_path
        return false
      end
    else
      redirect_to patient_log_in_path
      return false
    end
  end

  def destroy_ph
    session[:physician_id] = nil
    redirect_to home_page_path, notice: "Logged out!"
    return false
  end

  def destroy_pt
    session[:patient_id] = nil
    redirect_to home_page_path, notice: "Logged out!"
    return false
  end

end