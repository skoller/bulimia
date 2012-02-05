xml.instruct!
xml.Response do 
  if @error == "number_problem_1"
    xml.Sms("The system does not recognize this number. Please send texts only from the phone number associated with your account.")
  
  elsif @error == "number_problem_2"
    xml.Sms("There is a problem with the number you are texting from. Please send texts only from the phone number associated with your account.")
 
  elsif @error == "day_error"
    xml.Sms("There was a problem with your response. Please try again. Text 't' to enter food for today. Or text 'x' to enter food from yesterday.")
  elsif @error == "food_blank"
    xml.Sms("Your text cannot be blank. Please try again.")
   
  elsif @error == "time_missing_am_pm"
    xml.Sms("You must include am or pm in your text. Please try again. Around what time did you begin this meal/snack/binge?")
    
  elsif @error == "time_blank"
    xml.Sms("Your text cannot be blank. Please try again. Around what time did you begin this meal/snack/binge? Remember to include am/pm.")
    
  elsif @error == "bvl_blank"
    xml.Sms("Your text cannot be blank. Please try again. Include the letters 'B' if this was a binge, 'V' if you vomited, and/or 'L' if you took a laxative.")
    
  elsif @error == "personal_notes_blank"
    xml.Sms("Your text cannot be blank. Please try again. Text details about your thoughts/feelings or the circumstances of this eating event.")
  
  else
    xml.Sms("Something went wrong! Please contact tech support at XXX-XXX-XXXX")
  end
  
end