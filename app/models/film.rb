class Film < ApplicationRecord
  has_many :inventories
  has_many :stores, through: :inventories
  has_many :rentals, through: :inventories

  belongs_to :language
end
