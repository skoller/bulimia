xml.instruct!
xml.Response do 
  xml.Sms("Hi #{@patient.first_name.capitalize}. How many minutes ago did you vomit? Text 'h' to respond in hours.")
end