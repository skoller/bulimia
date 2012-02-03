class PhoneController < ApplicationController
  
  BASE_DIR = "phone/"  

  def day
    
    number = params['From']
    number_mod = number.tr('+-/)/(', '')

    if ( number_mod =~ /^1\d(10)/ ) || ( number_mod =~ /^\d(10)/ )

      if number_mod.size == 11
        processed_num = number_mod.slice!(1..10)
        nubmer = processed_num
      elsif number_mod.size == 10
        processed_num = number_mod.slice!(0..9)
        number = processed_num
      end
    else
      render BASE_DIR + "try_again.xml"
      return false
    end

    @texter = Patient.where(:phone_number => number)

    if @texter.exists?
      session[:ph] = number
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
