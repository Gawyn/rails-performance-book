class Film < ApplicationRecord
  has_many :inventories
  has_many :stores, through: :inventories
  belongs_to :language
end
