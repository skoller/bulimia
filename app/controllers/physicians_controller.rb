class PhysiciansController < ApplicationController

  before_filter :authenticate_user, :except => [:new, :create]
  
  
  def new
    @physician = Physician.new
    @no_session_format = true
    session[:physician_id] = nil
    session[:patient_id] = nil 
  end

  def create
    @physician = Physician.new(params[:physician])
    if @physician.save
      redirect_to matched_path(params[:physician])
    else
      render 'new'
    end
  end

  
  def show
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      if (session[:physician_id] == 1)
        @admin_ph = true
        @physician = Physician.find(params[:id])
      elsif ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s))
        @normal_ph = true
      end
    else
      patient_restriction
    end
  end

  def edit
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @physician = Physician.find(params[:id])
    else
      patient_restriction
    end
  end

  def update
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:physician_id])
      if (@ph.update_attributes(params[:physician]))
        redirect_to physician_path(@ph), :notice => "Your updates were successful."
      else
        redirect_to :action => 'edit'
      end
    elsif ((session[:physician_id]).to_s && ((params[:id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:id])
      if @ph.first_name == nil
        (@ph.update_attributes(params[:physician]))
        redirect_to welcome_ph_instructions_path(:physician_id => @ph.id)
      elsif @ph.first_name
        (@ph.update_attributes(params[:physician]))
        redirect_to physician_patients_path(@ph)
      else
          redirect_to :action => 'physician_additional_information'
      end
    else
      patient_restriction
    end
  end

  def ph_password_edit
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @patient = Patient.find(params[:patient_id])
      @ph = Physician.find(@patient.physician_id)  
    else
      patient_restriction
    end
  end

  def ph_password_update
    if ((session[:physician_id]).to_s && ((params[:physician_id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @patient = Patient.find(params[:patient_id])
      @ph = Physician.find(@patient.physician_id)

      if @patient.update_attributes(params[:patient])
        redirect_to physician_patient_path(@ph, @patient), :notice => "The patient's password was successfully reset"
      else
        render :action =>"admin_pt_password_edit"
      end
    else
      patient_restriction
    end
  end


  def destroy_archive
    if (session[:physician_id] == 1)
      @physician = Physician.find(params[:id])
      @physician.archive = true
      @physician.arch_id = @physician.id
      @physician.id = nil
      @physician.email = @physician.email + "(BIVOLA_archive_BIVOLA)"
      @physician.save(:validate => false)
      redirect_to admin_path
    else
      patient_restriction
    end
  end

  def deactivate_message
    @ph = Physician.find(params[:physician_id])
    @pt = Patient.find(params[:patient_id])
  end
  
  def physician_additional_info
    if ((session[:physician_id]).to_s && ((params[:id]) == (session[:physician_id]).to_s)) || (session[:physician_id] == 1)
      @ph = Physician.find(params[:id])
    else
      patient_restriction
    end
  end
  
  def welcome_ph_instructions
    @ph = Physician.find(params[:physician_id])
  end
  
def pt_archive_index
  @ph = Physician.find(params[:physician_id])
  @pt_arch = @ph.patients.where(:archive => true).all
end

end