class PhoneController < ApplicationController
  
  BASE_DIR = "phone/"  

  def day
    if ( params['From'] =~ /^1\d(10)/ ) || ( params['From'] =~ /^\d(10)/ ) || ( params['From'] =~ /\+^1\d(10)/ )
      entry = params['From']
      if entry.size == 11
        entry.slice!(0)
        nubmer = entry
      elsif entry.size == 10
        number = entry
      elsif entry.size == 12
        entry.slice!(1)
        number = entry
      end
    else
      render "phone/error xml text"
      return false
    end
  
    @texter = @patient.where(:phone_number => number).first

    if @texter
      session[:ph] = number
      render BASE_DIR + 'day.xml'
      return false
    else
      @error = true
      render BASE_DIR +'try_again.xml' 
      return false
    end

    def day_interpret
      render BASE_DIR + 'cool.xml'
    end
  end
