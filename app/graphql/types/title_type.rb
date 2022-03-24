class Types::TitleType < Types::BaseObject
  field :id, ID, null: false
  field :key, Integer, null: false, method: :id
  field :title, String, null: false
  field :slug, String, null: false,method: :to_param
  field :latest_published_edition, Types::EditionType,null: true,camelize: false
  field :editions, [Types::EditionType], null: true
  field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  field :contributions, [Types::ContributionType], null: true
  field :categories, [Types::CategoryType], null: true
  field :title_lists, [Types::TitlelistType], null: true,camelize: false
end
