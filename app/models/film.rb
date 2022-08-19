class Film < ApplicationRecord
  has_many :inventories
  belongs_to :language
end
