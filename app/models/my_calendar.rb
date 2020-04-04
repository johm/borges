class MyCalendar 

  def self.new(events)
    RiCal.Calendar do |cal| 
#      cal.default_tzid="America/New_York"
      events.each do |e|
        cal.event do    
          dtstart       e.event_start.set_tzid("America/New_York") # + 5.hours
          dtend         e.event_end .set_tzid("America/New_York") # + 5.hours
          summary     e.title
          description "From redemmas"
        end
      end
    end
  end
end

