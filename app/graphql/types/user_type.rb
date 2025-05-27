# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :email, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :post_count, Integer, null: false
    field :posts, [ Types::PostType ], null: false

    def post_count
      object.posts.size
    end
  end
end
