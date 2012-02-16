class PhysiciansController < ApplicationController
  
  def new
    @physician = Physician.new
    @no_session_format = true
  end
  
  def create
    @physician = Physician.new(params[:physician])
    if @physician.save
      redirect_to matched_path(params[:physician])
    else
      render 'new'
    end
  end
  
end