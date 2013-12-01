# This class exists to a) persist search form values across requests and b) do so in a way which allows the use of Rails' neato form logic

class DateRangeObject < OpenStruct
  def self.model_name
    FakeActiveModelName.new
  end
end


class FakeActiveModelName
  def param_key
    "date_range_object"
  end
  def human
    "DateRangeObject"
  end
end
