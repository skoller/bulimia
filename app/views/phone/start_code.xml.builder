xml.instruct!
xml.Response do 
  xml.Sms("Dr. #{@ph.full_name} has activated your Bivola Account. Important! Please read all five text messages you receive following this message.")
  xml.Sms("Bivola saves text messages you send it and creates diary entries in your web account for you and your doctor to review.")
  xml.Sms("Sound complicated? Dont worry! It's simple to use!")
  xml.Sms("Step 1: Save 310- as 'My Bivola Diary' in your cell phone's address book so you can easily find it again.")
  xml.Sms("Step 2: Start creating diary entries immediatly after you eat, take a laxative, or vomit.")
  xml.Sms("To create a new a diary entry, text either 'Food' 'Lax' or 'Vom' to Bivola based on what event you are recording.")
  xml.Sms("If you ate or drank anything start by texting 'food'. Text 'lax' to record only laxative use . Text 'vom' to record only vomiting.")
  xml.Sms("To delete an entry in progress, text 'cancel' at any time. Text 'help' for a reminder on how to create diary entries."
  xml.Sms("To view or edit your saved diary entries online by visiting www.bivola.com. Click 'New Patient Sign Up' and enter '#{@patient.start_code}' as your start code.")
end