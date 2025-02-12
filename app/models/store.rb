class Store < ApplicationRecord
  has_many :inventories
  has_many :films, through: :inventories
  belongs_to :most_rented_film, class_name: 'Film'


  def most_rented_film
    Film.find(Rental.joins(:inventory)
      .where(inventory: {store_id: id})
      .group(:film_id).count.max_by { |k, v| v }.last)
  end
end
