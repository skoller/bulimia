class PhoneController < ApplicationController
  
  BASE_DIR = "phone/"  

  def sms_handler
    
    number = params['From']
    
        
               if session[:day] == true && session[:text_convo] = true
                 render BASE_DIR + 'cool.xml'
                 return false
                 # if params['Body'] = "t"
                 #                    @pt = Patient.where(:phone_number => session[:ph])
                 #                    @sms_log_entr = @pt.log_entries.build
                 #                    @sms_log_entry.day = 16
                 #                    @sms_log_entry.date = Date.now
                 #                    @sms_log_entry.save(:validate => :false)
                 #                    session[:day] = :false
                 #                    return false
                 #                  elsif params['Body'] = "x"
                 #                    @pateint = Patient.where(:phone_number => session[:ph])
                 #                  else
                 #                    @error_day = true
                 #                    render BASE_DIR + "day.xml"
                 #                    return false
                 #                  end
               end
               
               if session[:time] == true && session[:text_convo] = true
                 #####
               end
               
               if session[:food] == true && session[:text_convo] = true
                 #####
               end
               
               if session[:bvl] == true && session[:text_convo] = true
                 #####
               end
               
               if session[:note] == true && session[:text_convo] = true
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
      session[:text_convo] = true
      session[:ph] = number
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
