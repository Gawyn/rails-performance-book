task reset_customer_counters: :environment do
  Customer.all.each do |customer|
    Customer.reset_counters(customer.id, :rentals)
  end
end
