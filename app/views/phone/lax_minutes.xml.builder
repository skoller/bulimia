xml.instruct!
xml.Response do 
  xml.Sms("Hi #{@patient.first_name.capitalize}. How many minutes ago did you take this laxative? Text 'h' to respond in hours.")
end