require 'csv'

pp 'Destroying previous DB'
[Customer, Film, Inventory, Language, Rental, Store].each(&:delete_all)

pp 'Creating films'
data = CSV.read('lib/data.csv')
n = data.count
language_i = 1
language_ids = {}
data.each_with_index do |content, i|
  title, language_name = content
  puts "Creating film #{i+1} of #{n}"
  language_id = language_ids[language_name]
  unless language_id
    language = Language.new(id: language_i, name: language_name)
    language.save
    language_ids[language_name] = language_i
    language_i += 1
  end
  Film.new(id: i + 1, title: title, language_id: language_id).save
end
long_text = File.open('lib/assets/long_text.txt').read[0..64000]
Film.update_all(big_text_column: long_text)

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

1000.times do
  Customer.create(name: "Dummy Costumer")
end

# Matz follows everyone
Customer.where("id > 1").each do |customer|
  Following.create(follower_id: 1, followed_id: customer.id)
end
