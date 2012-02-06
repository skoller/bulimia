xml.instruct!
xml.Response do 
  xml.Sms("Hi #{@patient.first_name.capitalize}. Text 'T' to enter food for today. Or text 'X' to enter food from yesterday.")
end