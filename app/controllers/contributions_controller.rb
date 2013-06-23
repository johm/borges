class ContributionsController < ApplicationController
  autocomplete :author, :full_name, :full=>true, :display_value=>:name_and_id_and_titles
end
