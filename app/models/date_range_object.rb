# This class exists to a) persist search form values across requests and b) do so in a way which allows the use of Rails' neato form logic

class DateRangeObject < OpenStruct
  def self.model_name
    DRFakeActiveModelName.new
  end
end


class DRFakeActiveModelName
  def param_key
    "date_range_object"
  end
  def human
    "DateRangeObject"
  end
end
