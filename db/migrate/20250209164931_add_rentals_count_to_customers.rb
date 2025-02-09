class AddRentalsCountToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_column :customers, :rentals_count, :integer
  end
end
