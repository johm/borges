class Types::EditionType < Types::BaseObject
  field :id, ID, null: false
  field :isbn13, String, null: true
  field :format, String, null: true
  field :list_price, String, null: false
  field :cover_image_url,String,null: true,camelize: false
  field :opengraph_image_url,String,null: true,camelize: false
  
#field :title,Types::TitleType, null: false
end
