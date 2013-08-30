# This class exists to a) persist search form values across requests and b) do so in a way which allows the use of Rails' neato form logic

class SearchObject < OpenStruct
  def self.model_name
    FakeActiveModelName.new
  end
end


class FakeActiveModelName
  def param_key
    "search_object"
  end
  def human
    "SearchObject"
  end
end
