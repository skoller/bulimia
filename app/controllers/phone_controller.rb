class PhoneController < ApplicationController
  
  BASE_DIR = "phone/" 
  
  def sms_handler
    
    ######### number / patient identification
    raw_number = params['From']
    number_mod = raw_number.tr('+-/)/(', '')

    if ( number_mod =~ /^1\d(10)/ ) || ( number_mod =~ /^\d(10)/ )
      
      if number_mod.size == 11
        @processed_num = number_mod.slice(1..10)
      elsif number_mod.size == 10
        @processed_num = number_mod.slice(0..9)
      end
      
      if Patient.where(:phone_number => @processed_num).exists?
       @patient = Patient.where(:phone_number => @processed_num).first
      else
        @error = "number_problem_1"
        render BASE_DIR + "error.xml"
        return false
      end
      
    else
      @error = "number_problem_2"
      render BASE_DIR + "error.xml"
      return false
    end
    
    
    
    # conversation intiation code at the end of the method
    # arranged in order of conversation sequence timeline
    
    ########## day
    if @patient.convo_handler.state == 'day'
      @log_e = LogEntry.where(:convo_handler_id => @patient.convo_handler.id )
      @ch = @patient.convo_handler.state
      if (params['Body']).downcase!.delete!(" ") == "t"
        @log_e.date = DateTime.now 
        @log_e.save(:validate => :false)
        @log_e.day = @patient.determine_log_entry_day_index(@log_e)
        @log_e.save(:validate => :false)
        @ch.state = 'food'
        @ch.save(:validate => :false)
        render BASE_DIR + "food.xml"
        return false
      elsif (params['Body']).downcase!.delete!(" ") == "x"
        @log_e.date = DateTime.yesterday 
        @log_e.save(:validate => :false)
        @ch.state = 'food'
        @ch.save(:validate => :false)
        render BASE_DIR + "food.xml"
        return false
      else 
        @error = "day_error"
        render BASE_DIR + "error.xml"
        return false    
      end
         
    ########## food 
    elsif @patient.convo_handler.state == 'food'
      @ch = @patient.convo_handler.state
      unless (params["Body"]).delete!(" ") == ""
        @log_e = LogEntry.where(:convo_handler_id => @patient.convo_handler.id )
        @log_e.food = (params['Body']).squeeze!(" ")
        @log_e.save(:validate => :false)
        @ch.state = 'time'
        @ch.save(:validate => :false)
        render BASE_DIR + "time.xml"
        return false
      else
        @error = "food_blank"
        render BASE_DIR + "error.xml"
        return false
      end
      
    ########## time
    elsif @patient.convo_handler.state == 'time'
      @ch = @patient.convo_handler.state
      unless (params["Body"]).delete!(" ") == ""
        @log_e = LogEntry.where(:convo_handler_id => @patient.convo_handler.id )
        @log_e.time = (params['Body']).squeeze!(" ")
        if (params['body']).downcase!.delete!(" ").include? "am"
          @log_e.save(:validate => :false)
          @ch.state = 'bvl'
          @ch.save(:validate => :false)
          @am_established = true
          render BASE_DIR + "bvl.xml"
          return false
        end
        if ( !@am_established ) && ( (params['body']).downcase!.delete!(" ").include? "pm" )
          @log_e.save(:validate => :false)
          @ch.state = 'bvl'
          @ch.save(:validate => :false)
          render BASE_DIR + "bvl.xml"
          return false
        else
          @error = "time_missing_am_pm"
          render BASE_DIR + "error.xml"
          return false
        end
        
      else
        @error = "time_blank"
        render BASE_DIR + "error.xml"
        return false
      end
    
    ########### bvl  
    elsif @patient.convo_handler.state == 'bvl'
      @ch = @patient.convo_handler.state
      unless (params["Body"]).delete!(" ") == ""
        @log_e = LogEntry.where(:convo_handler_id => @patient.convo_handler.id )
        binge_in_body(@log_e) #### these methods save the gathered info to the database
        vomit_in_body(@log_e)
        lax_in_body(@log_e)
        nothing_happened(@log_e)
        @ch.state = 'note'
        @ch.save(:validate => :false)
        render BASE_DIR + "notes.xml"
        return false
      else
        @error = "bvl_blank"
        render BASE_DIR + "error.xml"
        return false
      end  
    
    ########### personal_notes 
    elsif @patient.convo_handler.state == 'note'
      @ch = @patient.convo_handler.state
      unless (params["Body"]).delete!(" ") == ""
        @log_e = LogEntry.where(:convo_handler_id => @patient.convo_handler.id )
        @log_e.personal_notes = (params['Body']).squeeze!(" ")
        @log_e.save(:validate => :false)
        render BASE_DIR + "thank_you.xml"
        return false
      else
        @error = "personal_notes_blank"
        render BASE_DIR + "error.xml"
        return false
      end
      
    ########### convo initiation  
    else
      if @patient
        @ch = ConvoHandler.new
        @ch.patient_id = @patient.id
        @ch.state = 'day'
        @ch.save(:validate => :false)
        @le = LogEntry.new
        @le.patient_id = @patient.id
        @le.convo_handler_id = @patient.convo_handler.id
        @le.save(:validate => :false)
        @ch.log_entry_id = @le.id
        @ch.save(:validate => :false)
        render BASE_DIR + "day.xml"
        return false
      else
        @error = "number_problem"
        render BASE_DIR + "error.xml"
        return false
      end
    end

  end
  
  
  
  
  ######### bvl sub-methods
  def binge_in_body(entry)
    if (params['Body']).downcase!.include? ?b
      entry.binge = true
      entry.save(:validate => :false)
    end
  end
  
  def vomit_in_body(entry)
    if (params['Body']).downcase!.include? ?v
      entry.vomit = true
      entry.save(:validate => :false)
    end
  end
  
  def lax_in_body(entry)
    if (params['Body']).downcase!.include? ?l
      entry.laxative = true
      entry.save(:validate => :false)
    end
  end
    
  def nothing_happened(entry)
    if (params['Body']).downcase!.delete!(" ") == "x"
      entry.laxative = false
      entry.binge = false
      entry.vomit = false
      entry.save(:validate => :false)
    end
  end
  
  
  
  
  
end  

