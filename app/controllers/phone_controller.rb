class PhoneController < ApplicationController
  
  BASE_DIR = "phone/" 
  
  def convo_handler_state_changer
        raw_number = params['From']
        number_mod = raw_number.tr('+-/)/(', '')

        if ( number_mod =~ /^1\d(10)/ ) || ( number_mod =~ /^\d(10)/ )
          if number_mod.size == 11
            @processed_num = number_mod.slice!(1..10)
          elsif number_mod.size == 10
            @processed_num = number_mod.slice!(0..9)
          end
        else
          render BASE_DIR + "number_problem.xml"
          return false
        end
    
    if @ch 
      
      
    else
      
        
      
      @ch = Convo_handler.build
      @ch.patient_id = Patient.where(:phone_number => @processed_num).first.id
      @ch.state = 'start'
      @ch.save(:validate => :false)
      @le = Log_entry.build
      @le.patient.id = Patient.where(:phone_number => @processed_num).first.id
      @le.food = "THIS IS A TEST"
      @le.save(:validate => :false)
      @ch.log_entry_id = @le.id
      @ch.save(:validate => :false)
      session[:sms_convo] = params['From']
      render BASE_DIR + "cool.xml"
    end
    
  end
  
  
  
  
  
  
  
  
