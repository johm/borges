module EventsHelper

  def previous_month(month,year)
    month == 1 ? 12 : month - 1
  end

  def next_month(month,year)
    month == 12 ? 1 : month + 1
  end

  def previous_year(month,year)
    month == 1 ? year - 1  : year 
  end
  
  def next_year(month,year)
    month == 12 ? year + 1  : year 
  end


end
