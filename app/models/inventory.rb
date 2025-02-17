class Inventory < ApplicationRecord
  MAX_AMOUNT_PER_STORE = 10000

  belongs_to :film
  belongs_to :store

  has_many :rentals

  validate :max_amount_of_inventory_per_store

  private

  def max_amount_of_films_per_store
    if store.inventories.count >= MAX_AMOUNT_PER_STORE
      errors.add(:store, 'Store has the max amount of items.')
    end
  end
end
