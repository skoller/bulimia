xml.instruct!
xml.Response do 
  xml.Sms("Hi #{@patient.first_name.capitalize}. About how many minutes ago did you vomit? Text 'h' to enter your response in hours.")
end