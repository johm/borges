class Types::CategoryType < Types::BaseObject
  field :id, ID, null: false
  field :key, Integer, null: false, method: :id
  field :name, String, null: false
  field :slug, String, null: false,method: :to_param
  field :description, String, null: true  
  field :image_url,String,null: true,camelize: false
  field :titles,[Types::TitleType], null: true
end
