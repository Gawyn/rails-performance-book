class AddRentalsCountToCustomers < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :rentals_count, :integer
  end
end
