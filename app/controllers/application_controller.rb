class ApplicationController < ActionController::Base
  
  def home_page
    @no_session_format = true
    if session[:physician_id]
      session[:physician_id] = nil
    elsif session[:patient_id]
       session[:patient_id] = nil
    end
  end
  
  
  def patient_restriction
  if session[:patient_id]
     pt_id = session[:patient_id]
     @pt = Patient.find(pt_id)
     @ph = Physician.find(@pt.physician_id)
     redirect_to physician_patient_log_entries_path(@ph, @pt), :notice => "That page has restricted access."
   else
     redirect_to home_page_path
   end
 end
 
 def physician_restriction
 if session[:physician_id]
    ph_id = session[:physician_id]
    @ph = Physician.find(ph_id)
    redirect_to physician_patient_log_entries_path(@ph), :notice => "That page has restricted access."
  else
    redirect_to home_page_path
  end
end
  
  

  private

  def current_physician
    @current_physician ||= Physician.find(session[:physician_id]) if session[:physician_id]
  end
  
  def authenticate_user
    if session[:physician_id] || session[:patient_id]
    else
      redirect_to home_page_path
    end
  end
  
  def restrict_access_to_relevant_pages
      if ((session[:patient_id]).to_s && ((params[:patient_id]) == (session[:patient_id]).to_s)) || ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s))
      else
        redirect_to home_page_path
      end
  end
  
  def current_patient
    @current_patient ||= Patient.find(session[:patient_id]) if session[:patient_id]
  end
  
  
  helper_method :current_physician
  helper_method :current_patient
  
end
