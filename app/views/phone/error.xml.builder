xml.instruct!
xml.Response do 
  if @error == "number_problem_1"
    xml.Sms("The system does not recognize this number. Please send texts only from the phone number associated with your account.")
  
  elsif @error == "number_problem_2"
    xml.Sms("There is a problem with the number you are texting from. Please send texts only from the phone number associated with your account.")
 
  elsif @error == "day_error"
    xml.Sms("There was a problem with your response. Please try again.")
    xml.Sms("this is a test")
  elsif @error == "food_blank"
    xml.Sms("Your text cannot be blank. Please try again.")
   
  elsif @error == "time_missing_am_pm"
    xml.Sms("You must include am or pm in your text. Please try again.")
    
  elsif @error == "time_blank"
    xml.Sms("Your text cannot be blank. Please try again.")
    
  elsif @error == "bvl_blank"
    xml.Sms("Your text cannot be blank. Please try again.")
    
  elsif @error == "personal_notes_blank"
    xml.Sms("Your text cannot be blank. Please try again.")
  
  else
    xml.Sms("Something went wrong! Please contact tech support at XXX-XXX-XXXX")
  end
  
end