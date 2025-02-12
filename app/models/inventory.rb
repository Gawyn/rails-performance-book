class Inventory < ApplicationRecord
  belongs_to :film
  belongs_to :store

  has_many :rentals
end
