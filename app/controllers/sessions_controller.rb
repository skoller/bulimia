class SessionsController < ApplicationController
  
def new_physician_session
  @no_session_format = true
end

def new_patient_session
  @no_session_format = true
end

def create_ph_session
  ph = Physician.find_by_email(params[:email])
  if (ph.email == 'dev@bvl.com') && ph.authenticate(params[:password])
    session[:physician_id] = ph.id
    redirect_to admin_path(ph), notice: "Welcome Administrator!"
  elsif ph && ph.authenticate(params[:password])
    session[:physician_id] = ph.id
    redirect_to physician_patients_path(ph), notice: "Logged in!"
  else
    render "new", notice: "Invalid email or password"
  end
end

def create_pt_session
  pt = Patient.find_by_email(params[:phone_number])
  ph = pt.physician
  if pt && pt.authenticate(params[:password])
    session[:patient_id] = pt.id
    redirect_to physician_patient_log_entries_path(ph, pt), notice: "Logged in!"
  else
    render "new", notice: "Invalid email or password"
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