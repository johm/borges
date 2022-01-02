class Types::TitleType < Types::BaseObject
  field :id, ID, null: false
  field :title, String, null: false
  field :slug, String, null: false,method: :to_param
  field :latest_published_edition, Types::EditionType,null: true,camelize: false
  field :editions, [Types::EditionType], null: true
end
