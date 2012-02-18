class ApplicationController < ActionController::Base
  
  def home_page
    @no_session_format = true
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
  
  def current_patient
    @current_patient ||= Patient.find(session[:patient_id]) if session[:patient_id]
  end
  
  def authenticate_patient
    if session[:patient_id]
    else
      redirect_to patient_log_in_path
    end
  end
  
  
  helper_method :current_physician
  helper_method :current_patient
  
end
