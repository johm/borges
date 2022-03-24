class Types::PublisherType < Types::BaseObject
  field :id, ID, null: false
  field :key, Integer, null: false, method: :id
  field :name, String, null: false
end
