class Types::AuthorType < Types::BaseObject
  field :id, ID, null: false
  field :key, Integer, null: false, method: :id
  field :slug, String, null: false,method: :to_param
  field :full_name, String, null: false
  field :titles, [Types::TitleType], null: true # generally we build this from the title set instead of fetching 
end
