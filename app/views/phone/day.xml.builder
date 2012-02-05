xml.instruct!
xml.Response do 
  xml.Sms("Hi #{@patient.first_name.capitalize}. Text 't' to enter food for today. Or text 'x' to enter food from yesterday.")
end