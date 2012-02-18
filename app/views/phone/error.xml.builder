xml.instruct!
xml.Response do 
  if @error == "number_problem_1"
    xml.Sms("The system does not recognize this number. Please send texts only from the phone number associated with your account.")
   
  elsif @error == "number_problem_2"
    xml.Sms("There is a problem with the number you are texting from. Please send texts only from the phone number associated with your account.")
 
  elsif   @error == "intro_error"
    xml.Sms("Your response was not understood. Please text 'food' to enter an eating event. Text 'lax' to enter laxative use only. Text 'vom' to record vomiting only.")
      
  elsif @error == "when_minutes_error"
    xml.Sms("There was a problem with your response. Please try again. Using only numbers, text how many minutes ago this meal/snack/binge began.")
  
  elsif @error == "when_hours_error"
    xml.Sms("There was a problem with your response. Please try again. Using only numbers, text how many hours ago this meal/snack/binge began.")
  
  elsif @error == "lax_when_minutes_error"
    xml.Sms("There was a problem with your response. Please try again. Using only numbers, text how many minutes ago you took laxatives.")
  
  elsif @error == "lax_when_hours_error"
    xml.Sms("There was a problem with your response. Please try again. Using only numbers, text how many hours ago you took laxatives.")
  
  elsif @error == "vom_when_minutes_error"
    xml.Sms("There was a problem with your response. Please try again. Using only numbers, text how many minutes ago you vomited.")
  
  elsif @error == "vom_when_hours_error"
    xml.Sms("There was a problem with your response. Please try again. Using only numbers, text how many hours ago you vomited.")
  
  elsif @error == "food_blank"
    xml.Sms("Your text cannot be blank. Please try again.")
   
  # elsif @error == "time_missing_am_pm"
  #     xml.Sms("You must include am or pm in your text. Please try again. Around what time did you begin this meal/snack/binge?")
  #     
  #   elsif @error == "time_blank"
  #     xml.Sms("Your text cannot be blank. Please try again. Around what time did you begin this meal/snack/binge? Remember to include am/pm.")
  #    
  elsif @error == "where_blank"
    xml.Sms("Your text cannot be blank. Please try again. Where did you eat/drink these items?") 
    
  elsif @error == "bvl_blank"
    xml.Sms("Your text cannot be blank. Please try again. Include the letters 'B' if this was a binge, 'V' if you vomited, and/or 'L' if you took a laxative.")
    
  elsif @error == "personal_notes_blank"
    xml.Sms("Your text cannot be blank. Please try again. Text details about your thoughts/feelings or the circumstances of this eating event.")
  
  elsif @error == "convo_handler_state_undefined"
    xml.Sms("The convo handler state is either nil or in an unintentianally modified state.")
    
  # elsif @error == "lax_day_error"
  #     xml.Sms("There was a problem with your response. Please try again. Text 'T' if you took this laxative today. Text 'X' if you took this laxative yesterday.")
  #   
  #   elsif @error == "lax_time_missing_am_pm"
  #     xml.Sms("You must include am or pm in your text. Please try again. Around what time did you take this laxative?")
  #   
  #   elsif @error == "lax_time_blank"
  #     xml.Sms("Your text cannot be blank. Please try again. Around what time did you take this laxative? Remember to include am/pm.")
  #   
  elsif @error == "lax_note_blank"
    xml.Sms("Your text cannot be blank. Please try again. Please text details about your thoughts/feelings or the circumstances of this laxative use.") 
    
  elsif @error == "lax_dose_blank"
    xml.Sms("Your text cannot be blank. Please text details about the type of laxative and the dose you took.") 
  
  elsif @error == "vom_note_blank"
    xml.Sms("Your text cannot be blank. Please try again. Please text details about your thoughts/feelings or the circumstances of this vomiting event.")  
  
  
  else
    xml.Sms("Something went wrong! Please contact tech support at XXX-XXX-XXXX")
  end
  
end