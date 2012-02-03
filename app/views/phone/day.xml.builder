xml.instruct!
xml.Response do 
  xml.Sms("Hi #{@patient.first_name.capitalize}. Respond by texting 't' if this entry is for today's events or respond by texting 'x' if this entry is for yesterday's events.")
end