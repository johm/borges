class MyCalendar 

  def self.new(events)
    RiCal.Calendar do 
      events.each do |e|
        event do    
          dtstart       e.event_start
          dtend         e.event_end
          summary     e.title
          description "From redemmas"
        end
      end
    end
  end
end

