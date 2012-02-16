class SessionsController < ApplicationController
  
def new
  @no_session_format = true
end

def create
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

def destroy
  session[:physician_id] = nil
  redirect_to home_page_path, notice: "Logged out!"
end

end