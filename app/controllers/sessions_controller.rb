class SessionsController < ApplicationController
  
def new
  @no_session_format = true
end

def create
  ph = Physician.find_by_email(params[:email])
  if ph && ph.authenticate(params[:password])
    session[:physician_id] = ph.id
    redirect_to root_url, notice: "Logged in!"
  else
    render "new", notice: "Invalid email or password"
  end
end

def destroy
  session[:physician_id] = nil
  redirect_to log_in_path, notice: "Logged out!"
end

end