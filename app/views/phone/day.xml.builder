xml.instruct!
xml.Response do 
  xml.Sms("Hi #{@patient.first_name.capitalize}. Is this entry about today's events?")
  xml.Redirect("http://bvl.herokuapp.com/phone/day_interpret")
end