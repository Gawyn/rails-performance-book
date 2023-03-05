class AddMostRentedFilmIdToStores < ActiveRecord::Migration[7.0]
  def change
    add_column :stores, :most_rented_film_id, :integer
  end
end
