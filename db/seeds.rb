# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

pp 'Destroying previous DB'
[Film, Inventory, Language, Store].each(&:delete_all)

pp 'Creating films'
data = CSV.read('lib/data.csv')
long_text = File.open('lib/assets/long_text.txt').read[0..64000]
data.each do |title, language|
  Film.create(title: title, language: Language.find_or_create_by(name: language), big_text_column: long_text)
end

pp "Creating 10 stores"

10.times do |i|
  pp "Creating store number #{i+1}"
  store = Store.new(id: i+1)
  store.save(validate: false)

  film_ids = Film.pluck(:id)

  attrs = film_ids.map { |film_id| {film_id: film_id, store_id: store.id} }

  Inventory.insert_all attrs
end
