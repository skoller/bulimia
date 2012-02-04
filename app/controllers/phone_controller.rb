class PhoneController < ApplicationController
  
  BASE_DIR = "phone/" 
  
  def convo_handler_state_changer
    raw_number = params['From']
    number_mod = raw_number.tr('+-/)/(', '')

    if ( number_mod =~ /^1\d(10)/ ) || ( number_mod =~ /^\d(10)/ )
      if number_mod.size == 11
        @processed_num = number_mod.slice(1..10)
      elsif number_mod.size == 10
        @processed_num = number_mod.slice(0..9)
      end
      @patient = Patient.where(:phone_number => @processed_num).first
    else
      render BASE_DIR + "number_problem.xml"
      return false
    end
    
    
    if @patient.convo_handler.state == 'day'
      @log_e = LogEntry.where(:convo_handler_id => @patient.convo_handler.id )
      
    elsif @ch.state == 'food'
      @log_e = LogEntry.where(:convo_handler_id => @patient.convo_handler.id )
    elsif @ch.state == 'bvl'
      @log_e = LogEntry.where(:convo_handler_id => @patient.convo_handler.id )
    elsif @ch.state == 'note'
      @log_e = LogEntry.where(:convo_handler_id => @patient.convo_handler.id )


    else

      if @patient
        @ch = ConvoHandler.new
        @ch.patient_id = @patient.id
        @ch.state = 'day'
        @ch.save(:validate => :false)
        @le = LogEntry.new
        @le.patient_id = @patient.id
        @le.food = "THIS IS A TEST"
        @le.save(:validate => :false)
        @ch.log_entry_id = @le.id
        @ch.save(:validate => :false)
      else
        render BASE_DIR + "number_problem.xml"
        return false
      end
      render BASE_DIR + "cool.xml"
    end

  end

  
  
  
  
  
  
end  
