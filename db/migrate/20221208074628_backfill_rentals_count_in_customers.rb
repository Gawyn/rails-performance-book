class BackfillRentalsCountInCustomers < ActiveRecord::Migration[7.0]
  def change
    Customer.all.each do |customer|
      Customer.reset_counters(customer.id, :rentals)
    end
  end
end
