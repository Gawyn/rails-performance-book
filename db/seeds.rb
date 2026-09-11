require 'csv'

pp 'Destroying previous DB'
[Customer, Film, Inventory, Language, Rental, Store].each(&:delete_all)

pp 'Creating films'
data = CSV.read('lib/data.csv')
long_text = File.open('lib/assets/long_text.txt').read[0..64000]
n = data.count
language_i = 1
insert_data = data.map.with_index do |content, i|
  title, language_name = content
  puts "Creating film #{i+1} of #{n}"
  language = Language.where(name: language_name).first
  unless language
    language = Language.new(id: language_i, name: language_name)
    language.save
    language_i += 1
  end
  
  {
    id: i+1,
    title: title,
    language_id: language.id,
    big_text_column: long_text,
  }
end
total_chunks = n / 1000
insert_data.each_slice(1000).with_index do |slice, i|
  pp "Inserting film chunk #{i} of #{total_chunks}"
  Film.insert_all(slice)
end

pp "Creating 10 stores"

10.times do |i|
  pp "Creating store number #{i+1}"
  store = Store.new(id: i+1, name: "Store #{i+1}")
  store.save(validate: false)

  film_ids = Film.pluck(:id)

  attrs = film_ids.map { |film_id| {film_id: film_id, store_id: store.id} }

  Inventory.insert_all attrs
end

[
  'Yukihiro Matsumoto', 'Enthusiastic Rubyist', 'Experienced Rubyist',
  'Ruby Lover', 'Newbie Rubyist', 'DuckTyping Fan',
  'Rails Expert', 'Fullstack Developer', 'Hobbyist Programmer', 'MVC Guru'
].each_with_index do |name, i|
   customer = Customer.new(id: i+1, name: name)
   customer.save
   store = Store.find(i+1)

   100.times do |i|
     rental_date = (10 + (i * 7)).days.ago.beginning_of_day
     Rental.create(
       customer: customer,
       inventory: store.inventories.sample,
       rental_date: rental_date,
       returnal_date: rental_date + 3.days
     )
   end
end

max_customer_id = Customer.maximum(:id) || 0
1000.times do |i|
  Customer.create(id: max_customer_id + i + 1, name: "Dummy Customer")
end

# Matz follows everyone
Customer.where("id > 1").each do |customer|
  Following.create(follower_id: 1, followed_id: customer.id)
end
