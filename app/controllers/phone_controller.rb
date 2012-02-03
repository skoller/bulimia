class PhoneController < ApplicationController
  
  BASE_DIR = "phone/"  

  def day
    
    number = params['From']
    # session[:ph] = number
    
    if session[:day] == true && session[:ph] = number
      #####
    end
    
    if session[:time] == true
      #####
    end
    
    if session[:food] == true
      #####
    end
    
    if session[:bvl] == true
      #####
    end
    
    if session[:note] == true
      #####
    end
    
    ######################## First incoming text #############################
    
    number_mod = number.tr('+-/)/(', '')

    if ( number_mod =~ /^1\d(10)/ ) || ( number_mod =~ /^\d(10)/ )
      if number_mod.size == 11
        processed_num = number_mod.slice!(1..10)
        number = processed_num
      elsif number_mod.size == 10
        processed_num = number_mod.slice!(0..9)
        number = processed_num
      end
    else
      render BASE_DIR + "number_problem.xml"
      return false
    end

    @texter = Patient.where(:phone_number => number)

    if @texter.exists?
      session[:day] = true
      @patient = @texter.first
      render BASE_DIR + 'day.xml'
      return false
    else
      @error = true
      render BASE_DIR + 'try_again2.xml' 
      return false
    end
  end
  
  def day_interpret
      render BASE_DIR + 'cool.xml'
  end
end
