module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :film, FilmType, null: false do
      argument :id, Integer
    end

    field :films, [FilmType] do
      argument :ids, [Integer], required: false
    end

    def film(id: )
      Film.find(id)
    end

    def films(ids: nil)
      ids ? Film.where(id: ids) : Film.all
    end

    field :store, StoreType, null: false do
      argument :id, Integer
    end

    field :stores, [StoreType] do
      argument :ids, [Integer], required: false
    end

    def store(id: )
      Store.find(id)
    end

    def stores(ids: nil)
      ids ? Store.where(id: ids) : Store.all
    end
  end
end
