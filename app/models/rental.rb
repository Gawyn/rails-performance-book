class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :inventory
  has_one :film, through: :inventory
end
