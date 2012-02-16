class AdminController < ApplicationController
  
  def index
    @physicians = Physician.all
  end
  
end