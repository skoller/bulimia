xml.instruct!
xml.Response do 
  xml.Sms("Hi #{@patient.first_name.capitalize}. Respond by texting 't' if this entry is for today's events or 'x' for yesterday's events.")
  xml.Redirect('http://bvl.herokuapp.com/phone/day_interpret')
end