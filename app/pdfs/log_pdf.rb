class LogPdf < Prawn::Document
  
    def initialize(patient)
      super(top_margin: 40)
        @patient = patient
        patient_info 
        entries
       
    end
    
    def patient_info
      text "#{@patient.last_name.capitalize}, #{@patient.first_name.capitalize}", size: 20, style: :bold
      text "Date of Birth: #{@patient.dob}", size: 18, style: :bold
    end
    
    def entries
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
      
      def entry_rows
        [["Day", "Time", "Where", "Food", "Binge", "Vomit", "Lax", "Personal Notes"]] +
        @patient.log_entries.map do |entry|
          [entry.day_web_display, entry.time_web_display, entry.location, entry.food, b_v_l(entry.binge), b_v_l(entry.vomit), b_v_l(entry.laxative), entry.personal_notes]
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