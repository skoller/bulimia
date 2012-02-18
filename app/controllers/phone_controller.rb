class PhoneController < ApplicationController

  BASE_DIR = "phone/" 

  def sms_handler

    ######### number / patient identification
    raw_number = params['From']
    number_mod = raw_number.tr('/+/-/)/(', '')

    if ( number_mod =~ /^1\d{10}$/ ) || ( number_mod =~ /^\d{10}$/ )

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




    # arranged in order of conversation sequence timeline


    unless @patient.convo_handler

      ######## conversation initiation
      @ch = ConvoHandler.new
      @ch.patient_id = @patient.id
      if (params['Body']).downcase.delete(" ") == "food"
        @ch.state = 'food_when'
        @ch.save(:validate => :false)
        @le = LogEntry.new
        @le.patient_id = @patient.id
        @le.convo_handler_id = @ch.id
        @le.save(:validate => :false)
        @ch.log_entry_id = @le.id
        @ch.save(:validate => :false)
        render BASE_DIR + "food_minutes.xml"
        return false
      elsif (params['Body']).downcase.delete(" ") == "lax"
        @ch.state = 'lax_when'
        @ch.save(:validate => :false)
        @le = LogEntry.new
        @le.patient_id = @patient.id
        @le.convo_handler_id = @ch.id
        @le.laxative = true
        @le.save(:validate => :false)
        @ch.log_entry_id = @le.id
        @ch.save(:validate => :false)
        render BASE_DIR + "lax_minutes.xml"
        return false 
      elsif (params['Body']).downcase.delete(" ") == "vom"
        @ch.state = 'vom_when'
        @ch.save(:validate => :false)
        @le = LogEntry.new
        @le.patient_id = @patient.id
        @le.convo_handler_id = @ch.id
        @le.vomit = true
        @le.save(:validate => :false)
        @ch.log_entry_id = @le.id
        @ch.save(:validate => :false)
        render BASE_DIR + "vom_minutes.xml"
        return false
      elsif (params['Body']).downcase.delete(" ") == "help"
        render BASE_DIR + "help.xml"
        return false
      elsif (params['Body']).downcase.delete(" ") == "cancel"
        @ch.drop_it_like_its_hot
        render BASE_DIR + "cancel.xml"
        return false
      else
        @error = "intro_error"
        render BASE_DIR + "error.xml"
        return false
      end

    else 

      ############################ NEW SCHEMATIC ##########################
      if @patient.convo_handler.state == 'food_when'
        @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
        @ch = @patient.convo_handler
        if ((params['Body']).to_f == 0) && ((params['Body']).delete(" ") == "0")
          @log_e.date = DateTime.now
          @log_e.save(:validate => :false)
          @ch.state = 'food'
          @ch.save(:validate => :false)
          render BASE_DIR + "food.xml"
          return false
        elsif ((params['Body']).to_f.class == Float) && ((params['Body']).to_f != 0)
          @log_e.date = ( DateTime.now - ((params['Body']).to_f).minutes )
          @log_e.save(:validate => :false)
          @ch.state = 'food'
          @ch.save(:validate => :false)
          render BASE_DIR + "food.xml"
          return false
        elsif ((params['Body']).to_f == 0 ) && (((params['Body']).downcase.delete(" ")) == "h")
          @ch.state = 'food_when_hours'
          @ch.save(:validate => :false)
          render BASE_DIR + "food_hours.xml"
          retunr false
        elsif (params['Body']).downcase.delete(" ") == "cancel"
          @ch.drop_it_like_its_hot
          @log_e.drop_it
          render BASE_DIR + "cancel.xml"
          return false
        else 
          @error = "when_minutes_error"
          render BASE_DIR + "error.xml"
          return false    
        end


      elsif @patient.convo_handler.state == 'food_when_hours'
        @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
        @ch = @patient.convo_handler
        if ((params['Body']).to_f == 0) && ((params['Body']).delete(" ") == "0")
          @log_e.date = DateTime.now
          @log_e.save(:validate => :false)
          @ch.state = 'food'
          @ch.save(:validate => :false)
          render BASE_DIR + "food.xml"
          return false
        elsif ((params['Body']).to_f.class == Float) && ((params['Body']).to_f != 0)
          @log_e.date = ( DateTime.now - ((params['Body']).to_f).hours )
          @log_e.save(:validate => :false)
          @ch.state = 'food'
          @ch.save(:validate => :false)
          render BASE_DIR + "food.xml"
          return false
        elsif (params['Body']).downcase.delete(" ") == "cancel"
          @ch.drop_it_like_its_hot
          @log_e.drop_it
          render BASE_DIR + "cancel.xml"
          return false
        else 
          @error = "when_hours_error"
          render BASE_DIR + "error.xml"
          return false    
        end




        ########## day
        # if @patient.convo_handler.state == 'day'
        #       @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
        #       @ch = @patient.convo_handler
        #       if (params['Body']).downcase.delete(" ") == "t"
        #         @log_e.date = DateTime.now 
        #         @log_e.save(:validate => :false)
        #         @log_e.day = @patient.determine_log_entry_day_index(@log_e)
        #         @log_e.save(:validate => :false)
        #         @ch.state = 'food'
        #         @ch.save(:validate => :false)
        #         render BASE_DIR + "food.xml"
        #         return false
        #       elsif (params['Body']).downcase.delete(" ") == "x"
        #         @log_e.date = DateTime.yesterday 
        #         @log_e.save(:validate => :false)
        #         @ch.state = 'food'
        #         @ch.save(:validate => :false)
        #         render BASE_DIR + "food.xml"
        #         return false
        #       elsif (params['Body']).downcase.delete(" ") == "cancel"
        #         @ch.drop_it_like_its_hot
        #         @log_e.drop_it
        #         render BASE_DIR + "cancel.xml"
        #         return false
        #       else 
        #         @error = "day_error"
        #         render BASE_DIR + "error.xml"
        #         return false    
        #       end

        ########## food 
      elsif @patient.convo_handler.state == 'food'
        @ch = @patient.convo_handler
        if (params['Body']).downcase.delete(" ") == "cancel"
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @ch.drop_it_like_its_hot
          @log_e.drop_it
          render BASE_DIR + "cancel.xml"
          return false
        end
        unless (params["Body"]).delete(" ") == ""
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @log_e.food = (params['Body']).squeeze(" ")
          @log_e.save(:validate => :false)
          @ch.state = 'where'
          @ch.save(:validate => :false)
          render BASE_DIR + "where.xml"
          return false
        else
          @error = "food_blank"
          render BASE_DIR + "error.xml"
          return false
        end

        ######### where
      elsif @patient.convo_handler.state == 'where'
        @ch = @patient.convo_handler
        if (params['Body']).downcase.delete(" ") == "cancel"
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @ch.drop_it_like_its_hot
          @log_e.drop_it
          render BASE_DIR + "cancel.xml"
          return false
        end
        unless (params["Body"]).delete(" ") == ""
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @log_e.location = (params['Body']).squeeze(" ")
          @log_e.save(:validate => :false)
          @ch.state = 'bvl'
          @ch.save(:validate => :false)
          render BASE_DIR + "bvl.xml"
          return false
        else
          @error = "where_blank"
          render BASE_DIR + "error.xml"
          return false
        end

        ########## time
        # elsif @patient.convo_handler.state == 'time'
        #       @ch = @patient.convo_handler
        #       unless (params["Body"]).delete(" ") == ""
        #         @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
        #         if (params['Body']).downcase.delete(" ") == "cancel"
        #           @ch.drop_it_like_its_hot
        #           @log_e.drop_it
        #           render BASE_DIR + "cancel.xml"
        #           return false
        #         end
        #         if (params['Body']).downcase.delete(" ").include? "am"
        #           @log_e.time = (params['Body']).squeeze(" ")
        #           @log_e.save(:validate => :false)
        #           @ch.state = 'bvl'
        #           @ch.save(:validate => :false)
        #           @am_established = true
        #           render BASE_DIR + "bvl.xml"
        #           return false
        #         end
        #         if ( !@am_established ) && ( (params['Body']).downcase.delete(" ").include? "pm" )
        #           @log_e.time = (params['Body']).squeeze(" ")
        #           @log_e.save(:validate => :false)
        #           @ch.state = 'bvl'
        #           @ch.save(:validate => :false)
        #           render BASE_DIR + "bvl.xml"
        #           return false
        #         else
        #           @error = "time_missing_am_pm"
        #           render BASE_DIR + "error.xml"
        #           return false
        #         end
        #         
        #       else
        #         @error = "time_blank"
        #         render BASE_DIR + "error.xml"
        #         return false
        #       end

        ########### bvl  
      elsif @patient.convo_handler.state == 'bvl'
        @ch = @patient.convo_handler
        if (params['Body']).downcase.delete(" ") == "cancel"
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @ch.drop_it_like_its_hot
          @log_e.drop_it
          render BASE_DIR + "cancel.xml"
          return false
        end
        unless (params["Body"]).delete(" ") == ""
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          binge_in_body(@log_e) #### these methods save the gathered info to the database
          vomit_in_body(@log_e)
          lax_in_body(@log_e)
          if lax_in_body(@log_e)
            @ch.state = 'food_lax_dose'
            @ch.save(:validate => :false)
            render BASE_DIR + "bvl_lax_dose.xml"
            return false
          end
          nothing_happened(@log_e)
          @ch.state = 'note'
          @ch.save(:validate => :false)
          render BASE_DIR + "food_note.xml"
          return false
        else
          @error = "bvl_blank"
          render BASE_DIR + "error.xml"
          return false
        end  

      elsif @patient.convo_handler.state == 'food_lax_dose'
        @ch = @patient.convo_handler
        if (params['Body']).downcase.delete(" ") == "cancel"
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @ch.drop_it_like_its_hot
          @log_e.drop_it
          render BASE_DIR + "cancel.xml"
          return false
        end
        unless (params["Body"]).delete(" ") == ""
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @log_e.personal_notes = "LAXATIVE: " + (params['Body']).squeeze(" ")
          @ch.state = 'food_lax_note'
          @ch.save(:validate => :false)
          @log_e.save(:validate => :false)
          render BASE_DIR + "food_lax_note.xml"
          return false
        else
          @error = "lax_dose_blank"
          render BASE_DIR + "error.xml"
          return false
        end

        ########### personal_notes 
        
         elsif @patient.convo_handler.state == 'food_lax_note'
            @ch = @patient.convo_handler
            if (params['Body']).downcase.delete(" ") == "cancel"
              @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
              @ch.drop_it_like_its_hot
              @log_e.drop_it
              render BASE_DIR + "cancel.xml"
              return false
            end
            unless (params["Body"]).delete(" ") == ""
              @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
              if @log_e.personal_notes 
                @log_e.personal_notes = @log_e.personal_notes + "; NOTES: " + (params['Body']).squeeze(" ")
                @log_e.save(:validate => :false)
                render BASE_DIR + "thank_you.xml"
                @ch.drop_it_like_its_hot
                return false
              else
                @error = "personal_notes_blank"
                render BASE_DIR + "error.xml"
                return false
              end
            end
        
        
        
        
      elsif @patient.convo_handler.state == 'note'
        @ch = @patient.convo_handler
        if (params['Body']).downcase.delete(" ") == "cancel"
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @ch.drop_it_like_its_hot
          @log_e.drop_it
          render BASE_DIR + "cancel.xml"
          return false
        end
        unless (params["Body"]).delete(" ") == ""
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          if @log_e.personal_notes 
            @log_e.personal_notes = "NOTES: " + (params['Body']).squeeze(" ")
            @log_e.save(:validate => :false)
            render BASE_DIR + "thank_you.xml"
            @ch.drop_it_like_its_hot
            return false
          else
            @error = "personal_notes_blank"
            render BASE_DIR + "error.xml"
            return false
          end
        end

          ########### lax schematic

        elsif @patient.convo_handler.state == 'lax_when'
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @ch = @patient.convo_handler
          if ((params['Body']).to_f == 0) && ((params['Body']).delete(" ") == "0")
            @log_e.date = DateTime.now
            @log_e.location = "N/A"
            @log_e.food = "N/A"
            @log_e.binge = false
            @log_e.vomit = false
            @log_e.save(:validate => :false)
            @ch.state = 'lax_dose'
            @ch.save(:validate => :false)
            render BASE_DIR + "lax_dose.xml"
            return false
          elsif ((params['Body']).to_f.class == Float) && ((params['Body']).to_f != 0)
            @log_e.date = ( DateTime.now - ((params['Body']).to_f).minutes )
            @log_e.location = "N/A"
            @log_e.food = "N/A"
            @log_e.binge = false
            @log_e.vomit = false
            @log_e.save(:validate => :false)
            @ch.state = 'lax_dose'
            @ch.save(:validate => :false)
            render BASE_DIR + "lax_dose.xml"
            return false
          elsif ((params['Body']).to_f == 0 ) && (((params['Body']).downcase.delete(" ")) == "h")
            @ch.state = 'lax_when_hours'
            @ch.save(:validate => :false)
            render BASE_DIR + "lax_hours.xml"
            retunr false
          elsif (params['Body']).downcase.delete(" ") == "cancel"
            @ch.drop_it_like_its_hot
            @log_e.drop_it
            render BASE_DIR + "cancel.xml"
            return false
          else 
            @error = "lax_when_minutes_error"
            render BASE_DIR + "error.xml"
            return false    
          end

        elsif @patient.convo_handler.state == 'lax_when_hours'
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @ch = @patient.convo_handler
          if ((params['Body']).to_f == 0) && ((params['Body']).delete(" ") == "0")
            @log_e.date = DateTime.now
            @log_e.location = "N/A"
            @log_e.food = "N/A"
            @log_e.binge = false
            @log_e.vomit = false
            @log_e.save(:validate => :false)
            @ch.state = 'lax_dose'
            @ch.save(:validate => :false)
            render BASE_DIR + "lax_dose.xml"
            return false
          elsif ((params['Body']).to_f.class == Float) && ((params['Body']).to_f != 0)
            @log_e.date = ( DateTime.now - ((params['Body']).to_f).hours )
            @log_e.location = "N/A"
            @log_e.food = "N/A"
            @log_e.binge = false
            @log_e.vomit = false
            @log_e.save(:validate => :false)
            @ch.state = 'lax_dose'
            @ch.save(:validate => :false)
            render BASE_DIR + "lax_dose.xml"
            return false
          elsif (params['Body']).downcase.delete(" ") == "cancel"
            @ch.drop_it_like_its_hot
            @log_e.drop_it
            render BASE_DIR + "cancel.xml"
            return false
          else 
            @error = "lax_when_hours_error"
            render BASE_DIR + "error.xml"
            return false    
          end

        elsif @patient.convo_handler.state == 'lax_dose'
          @ch = @patient.convo_handler
          if (params['Body']).downcase.delete(" ") == "cancel"
            @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
            @ch.drop_it_like_its_hot
            @log_e.drop_it
            render BASE_DIR + "cancel.xml"
            return false
          end
          unless (params["Body"]).delete(" ") == ""
            @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
            @log_e.personal_notes = "LAXATIVE: " + (params['Body']).squeeze(" ")
            @log_e.save(:validate => :false)
            @ch.state = 'lax_note'
            @ch.save(:validate => :false)
            render BASE_DIR + "lax_note.xml"
            return false
          else
            @error = "lax_dose_blank"
            render BASE_DIR + "error.xml"
            return false
          end








          # elsif @patient.convo_handler.state == 'lax_when'
          #        @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          #        @ch = @patient.convo_handler
          #        if (params['Body']).downcase.delete(" ") == "t"
          #          @log_e.date = DateTime.now 
          #          @log_e.save(:validate => :false)
          #          @log_e.day = @patient.determine_log_entry_day_index(@log_e)
          #          @log_e.location = "N/A"
          #          @log_e.food = "N/A"
          #          @log_e.binge = false
          #          @log_e.vomit = false
          #          @log_e.save(:validate => :false)
          #          @ch.state = 'lax_time'
          #          @ch.save(:validate => :false)
          #          render BASE_DIR + "lax_time.xml"
          #          return false
          #        elsif (params['Body']).downcase.delete(" ") == "x"
          #          @log_e.date = DateTime.yesterday 
          #          @log_e.save(:validate => :false)
          #          @ch.state = 'lax_time'
          #          @ch.save(:validate => :false)
          #          render BASE_DIR + "lax_time.xml"
          #          return false
          #        elsif (params['Body']).downcase.delete(" ") == "cancel"
          #          @ch.drop_it_like_its_hot
          #          @log_e.drop_it
          #          render BASE_DIR + "cancel.xml"
          #          return false
          #        else 
          #          @error = "lax_day_error"
          #          render BASE_DIR + "error.xml"
          #          return false    
          #        end

          ######## lax time
          # elsif @patient.convo_handler.state == 'lax_time'
          #       @ch = @patient.convo_handler
          #       if (params['Body']).downcase.delete(" ") == "cancel"
          #         @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          #         @ch.drop_it_like_its_hot
          #         @log_e.drop_it
          #         render BASE_DIR + "cancel.xml"
          #         return false
          #       end
          #       unless (params["Body"]).delete(" ") == ""
          #         @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          #         if (params['Body']).downcase.delete(" ").include? "am"
          #           @log_e.time = (params['Body']).squeeze(" ")
          #           @log_e.save(:validate => :false)
          #           @ch.state = 'lax_note'
          #           @ch.save(:validate => :false)
          #           @am_established = true
          #           render BASE_DIR + "lax_note.xml"
          #           return false
          #         end
          #         if ( !@am_established ) && ( (params['Body']).downcase.delete(" ").include? "pm" )
          #           @log_e.time = (params['Body']).squeeze(" ")
          #           @log_e.save(:validate => :false)
          #           @ch.state = 'lax_note'
          #           @ch.save(:validate => :false)
          #           render BASE_DIR + "lax_note.xml"
          #           return false
          #         else
          #           @error = "lax_time_missing_am_pm"
          #           render BASE_DIR + "error.xml"
          #           return false
          #         end
          #         
          #       else
          #         @error = "lax_time_blank"
          #         render BASE_DIR + "error.xml"
          #         return false
          #       end

          ######### lax note  
        elsif @patient.convo_handler.state == 'lax_note'
          @ch = @patient.convo_handler
          if (params['Body']).downcase.delete(" ") == "cancel"
            @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
            @ch.drop_it_like_its_hot
            @log_e.drop_it
            render BASE_DIR + "cancel.xml"
            return false
          end
          unless (params["Body"]).delete(" ") == ""
            @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
            @log_e.personal_notes = @log_e.personal_notes + "; NOTES: " + (params['Body']).squeeze(" ")
            @log_e.save(:validate => :false)
            render BASE_DIR + "thank_you.xml"
            @ch.drop_it_like_its_hot
            return false
          else
            @error = "lax_note_blank"
            render BASE_DIR + "error.xml"
            return false
          end

          ######################################### vom schematic

        elsif @patient.convo_handler.state == 'vom_when'
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @ch = @patient.convo_handler
          if ((params['Body']).to_f == 0) && ((params['Body']).delete(" ") == "0")
            @log_e.date = DateTime.now
            @log_e.location = "N/A"
            @log_e.food = "N/A"
            @log_e.binge = false
            @log_e.laxative = false
            @log_e.save(:validate => :false)
            @ch.state = 'vom_note'
            @ch.save(:validate => :false)
            render BASE_DIR + "vom_note.xml"
            return false
          elsif ((params['Body']).to_f.class == Float) && ((params['Body']).to_f != 0)
            @log_e.date = ( DateTime.now - ((params['Body']).to_f).minutes )
            @log_e.location = "N/A"
            @log_e.food = "N/A"
            @log_e.binge = false
            @log_e.laxative = false
            @log_e.save(:validate => :false)
            @ch.state = 'vom_note'
            @ch.save(:validate => :false)
            render BASE_DIR + "vom_note.xml"
            return false
          elsif ((params['Body']).to_f == 0 ) && (((params['Body']).downcase.delete(" ")) == "h")
            @ch.state = 'vom_note'
            @ch.save(:validate => :false)
            render BASE_DIR + "vom_hours.xml"
            retunr false
          elsif (params['Body']).downcase.delete(" ") == "cancel"
            @ch.drop_it_like_its_hot
            @log_e.drop_it
            render BASE_DIR + "cancel.xml"
            return false
          else 
            @error = "vom_when_minutes_error"
            render BASE_DIR + "error.xml"
            return false    
          end


        elsif @patient.convo_handler.state == 'vom_when_hours'
          @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
          @ch = @patient.convo_handler
          if ((params['Body']).to_f == 0) && ((params['Body']).delete(" ") == "0")
            @log_e.date = DateTime.now
            @log_e.location = "N/A"
            @log_e.food = "N/A"
            @log_e.binge = false
            @log_e.laxative = false
            @log_e.save(:validate => :false)
            @ch.state = 'vom_note'
            @ch.save(:validate => :false)
            render BASE_DIR + "vom_note.xml"
            return false
          elsif ((params['Body']).to_f.class == Float) && ((params['Body']).to_f != 0)
            @log_e.date = ( DateTime.now - ((params['Body']).to_f).hours )
            @log_e.location = "N/A"
            @log_e.food = "N/A"
            @log_e.binge = false
            @log_e.laxative = false
            @log_e.save(:validate => :false)
            @ch.state = 'vom_note'
            @ch.save(:validate => :false)
            render BASE_DIR + "vom_note.xml"
            return false
          elsif (params['Body']).downcase.delete(" ") == "cancel"
            @ch.drop_it_like_its_hot
            @log_e.drop_it
            render BASE_DIR + "cancel.xml"
            return false
          else 
            @error = "vom_when_hours_error"
            render BASE_DIR + "error.xml"
            return false    
          end

        elsif @patient.convo_handler.state == 'vom_note'
          @ch = @patient.convo_handler
          if (params['Body']).downcase.delete(" ") == "cancel"
            @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
            @ch.drop_it_like_its_hot
            @log_e.drop_it
            render BASE_DIR + "cancel.xml"
            return false
          end
          unless (params["Body"]).delete(" ") == ""
            @log_e = LogEntry.where( :convo_handler_id => @patient.convo_handler.id ).first
            @log_e.personal_notes = "NOTES: " + (params['Body']).squeeze(" ")
            @log_e.save(:validate => :false)
            render BASE_DIR + "thank_you.xml"
            @ch.drop_it_like_its_hot
            return false
          else
            @error = "vom_note_blank"
            render BASE_DIR + "error.xml"
            return false
          end

          ########### convo_handler state is messed up  
        else
          @error = "convo_handler_state_undefined"
          render BASE_DIR + "error.xml"
          return false
        end
      end

    end




    ######### bvl sub-methods
    def binge_in_body(entry)
      if (params['Body']).downcase.include? ?b
        entry.binge = true
        entry.save(:validate => :false)
      end
    end

    def vomit_in_body(entry)
      if (params['Body']).downcase.include? ?v
        entry.vomit = true
        entry.save(:validate => :false)
      end
    end

    def lax_in_body(entry)
      if (params['Body']).downcase.include? ?l
        entry.laxative = true
        entry.save(:validate => :false)
        return true
      end
    end

    def nothing_happened(entry)
      if (params['Body']).downcase.delete(" ") == "x"
        entry.laxative = false
        entry.binge = false
        entry.vomit = false
        entry.save(:validate => :false)
      end
    end



  end  

