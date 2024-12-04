class CreateRental < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals do |t|
      t.integer :inventory_id
      t.integer :customer_id
      t.datetime :rental_date
      t.datetime :returnal_date

      t.timestamps
    end
  end
end
