class Inventory < ApplicationRecord
  belongs_to :film
  belongs_to :store
end
