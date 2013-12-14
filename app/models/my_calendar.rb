class MyCalendar 
  include Icalendar
  
  def self.new(events)
    cal = Calendar.new
    events.each do |e|
      cal.event do
        dtstart       e.event_start
        dtend         e.event_end
        summary     e.title
      end
    end
    cal.publish
    return cal
  end


end
