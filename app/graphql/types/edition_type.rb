class Types::EditionType < Types::BaseObject
  field :id, ID, null: false
  field :key, Integer, null: false, method: :id
  field :isbn13, String, null: true
  field :format, String, null: true
  field :publisher_name, String, null: true, method: :publisher_name,camelize: false
  field :publisher, Types::PublisherType,null: true
  field :year_of_publication, String, null: true,camelize: false
  field :list_price, String, null: false,method: :my_online_price,camelize: false
  field :cover_image_url,String,null: true,camelize: false
  field :opengraph_image_url,String,null: true,camelize: false

  
#field :title,Types::TitleType, null: false
end
