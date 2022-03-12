class Types::ContributionType < Types::BaseObject
  field :id, ID, null: false
  field :author, Types::AuthorType,null:true #should eliminate these in validation!
  field :what, String, null: true
end
