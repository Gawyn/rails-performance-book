class AddRentalCounterToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :rental_counter, :integer
  end
end
