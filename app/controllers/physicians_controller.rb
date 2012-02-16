class PhysiciansController < ApplicationController
  
  def new
    @physician = Physician.new
  end
  
  def create
    @physician = Physician.new(params[:physician])
    if @physician.save
      redirect_to root_url, :notice => "Signed Up!"
    else
      render 'new'
    end
  end
  
  def index
    @physicians = Physician.all
  end
  
end