module NestedForm
  class Builder < ::ActionView::Helpers::FormBuilder 
    def my_unique_id
      self.to_s.gsub(/[^0-9]/,'')
    end
  end
end
