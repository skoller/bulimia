class LogPdf < Prawn::Document
  
    def initialize(patient)
      super(top_margin: 50)
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
          columns(1..3).align = :right
          self.row_colors = ["DDDDDD", "FFFFFF"]
          self.header = true
        end
      end

      def entry_rows
        [["Day", "Time", "Food", "Binge", "Vomit", "Laxative", "Personal Notes"]] +
        @patient.log_entries.map do |entry|
          [entry.day, entry.time, entry.food, b_v_l(entry.binge), b_v_l(entry.vomit), b_v_l(entry.laxative), entry.personal_notes]
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