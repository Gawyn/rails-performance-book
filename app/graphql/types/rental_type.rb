# frozen_string_literal: true

module Types
  class RentalType < Types::BaseObject
    field :id, ID, null: false
    field :inventory_id, Integer
    field :customer_id, Integer
    field :rental_date, GraphQL::Types::ISO8601DateTime
    field :returnal_date, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
