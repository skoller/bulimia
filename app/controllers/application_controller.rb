class ApplicationController < ActionController::Base
  force_ssl

  private

  def current_physician
    @current_physician ||= Physician.find(session[:physician_id]) if session[:physician_id]
  end
  helper_method :current_physician
end
