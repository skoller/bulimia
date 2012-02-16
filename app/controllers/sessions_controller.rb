class SessionsController < ApplicationController

def create
  ph = Physician.find_by_email(params[:email])
  if ph && ph.authenticate(params[:password])
    session[:physician_id] = ph.id
    redirect_to root_url, :notice => "Logged in!"
  else
    flash.now.alert = "Invalid email or password"
    render "new"
  end
end

def destroy
  session[:physician_id] = nil
  redirect_to root_url, :notice => "Logged out!"
end

end