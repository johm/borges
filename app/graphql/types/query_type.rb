module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.


    field :title, TitleType, null: false, description: "Find a title by ID" do
      argument :id, ID, required: true
    end
    
    def title(id:)
      Title.find(id)
    end

    field :author, AuthorType, null: false, description: "Find a author by ID" do
      argument :id, ID, required: true
    end
    
    def author(id:)
      Author.find(id)
    end

    

    field :categories, [CategoryType], null: false, description: "Get all categories" 
    
    def categories
      Category.includes(:titles) # sort by what here?
    end

    field :titlelists, [TitlelistType], null: false, description: "Get all title lists" 
    
    def titlelists
      TitleList.where(:public => true).includes(:titles) # sort by what here?
    end
    

    field :authors, [AuthorType],null:false, description: "Get all authors" do
      argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false
    end
    
    def authors(**args)
      if args[:updated_at]
        Author.where('updated_at > ?',args[:updated_at]).includes(:titles)
      else
        Author.includes(:titles)
      end
    end

    
    field :edition, EditionType, null: false, description: "Find a edition by ID" do
      argument :id, ID, required: true
    end
    
    def edition(id:)
      Edition.find(id)
    end


    
    field :titles, [TitleType],null: false, description: "Get all titles" do
      argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false
    end


    def titles(**args)
      if args[:updated_at]
        Title.where('updated_at > ?',args[:updated_at]).includes(:editions,{:contributions => :author},:categories,:title_lists,:publishers)
       else
        Title.includes(:editions,{:contributions => :author},:categories,:title_lists)
      end
    end

    field :editions, [EditionType],null: false, description: "Get all editions"

    def editions
      Edition.all
    end

    field :publishers, [PublisherType],null: false, description: "Get all publishers"

    def publishers
      Publisher.all
    end
    
    
    
  end
end
