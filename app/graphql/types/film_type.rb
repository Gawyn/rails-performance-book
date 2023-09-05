# frozen_string_literal: true

module Types
  class FilmType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :language_id, Integer
    field :big_text_column, String
  end
end
