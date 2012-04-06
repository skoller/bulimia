class LogPdf < Prawn::Document
  
    def initialize(patient)
      super(top_margin: 40)
        @patient = patient
        patient_info 
        make_it
       
    end
    
    def patient_info
      text "#{@patient.last_name.capitalize}, #{@patient.first_name.capitalize}", size: 20, style: :bold
      text "Date of Birth: #{@patient.dob}", size: 18, style: :bold
    end
    
    def entries(entry_rows)
        move_down 20
        
        table entry_rows do
          
          row(0).font_style = :bold
          row(0).align = :center
          self.row_colors = ["DDDDDD", "FFFFFF"]
          self.header = true
          column(0).width = 35
          column(1).width = 55
          column(0..1).align = :center
          column(2).width = 90
          column(3).width = 100
          column(2..3).align = :left
          column(4..6).width = 45
          column(7).width = 125
          column(7).align = :left
        end
      end
      
   
    def make_it
       x = [["Day", "Time", "Where", "Food", "Binge", "Vomit", "Lax", "Personal Notes"]]
       ordered_log_entries = @patient.log_entries.order("date ASC")
       ordered_log_entries.each do |e|
         if @previous_day == nil
           single_page = x + (x.map { |e| [e.day_web_display, e.time_web_display, e.location, e.food, b_v_l(e.binge), b_v_l(e.vomit), b_v_l(e.laxative), e.personal_notes] })
           @previous_day = e.date.change(:hour => 0)
         elsif (e.date.change(:hour => 0) == @previous_day)
           single_page + (x.map { |e| [e.day_web_display, e.time_web_display, e.location, e.food, b_v_l(e.binge), b_v_l(e.vomit), b_v_l(e.laxative), e.personal_notes] })
           @previous_day = e.date.change(:hour => 0)
         else
           entries(single_page)
           LogPdf.start_new_page
           single_page = x + (x.map { |e| [e.day_web_display, e.time_web_display, e.location, e.food, b_v_l(e.binge), b_v_l(e.vomit), b_v_l(e.laxative), e.personal_notes] })
           @previous_day = e.date.change(:hour => 0)
         end
       end
    end
    
    

      def b_v_l(val)
        if val
          "X"
        else
          " "
        end
      end
end