xml.instruct!
xml.Response do 
  xml.Sms("Your Bivola account is now active. Visit www.bivola.com and use xxxxx as your start code to sign up for online access to your diary entries.")
  xml.Redirect("http://bvl.herokuapp.com/after_start_code_web_handler")
end