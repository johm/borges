class MyCalendar 

  def self.new(events)
    RiCal.Calendar do 
      events.each do |e|
        event do    
          dtstart       e.event_start + 5.hours
          dtend         e.event_end + 5.hours
          summary     e.title
          description "From redemmas"
        end
      end
    end
  end
end

