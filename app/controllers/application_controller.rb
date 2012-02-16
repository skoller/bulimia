class ApplicationController < ActionController::Base
  
  def home_page
    @no_session_format = true
  end

  private

  def current_physician
    @current_physician ||= Physician.find(session[:physician_id]) if session[:physician_id]
  end
  
  def authenticate_physician
    if session[:physician_id]
    else
      redirect_to log_in_path
    end
  end
  
  
  helper_method :current_physician
  
  
end
