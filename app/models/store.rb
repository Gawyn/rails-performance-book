class Store < ApplicationRecord
  has_many :inventories
  has_many :films, through: :inventories
end
