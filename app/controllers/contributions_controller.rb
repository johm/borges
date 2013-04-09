class ContributionsController < ApplicationController
  autocomplete :author, :full_name, :full=>true
end
