# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

p 'Destroying previous DB'
[Film, Inventory, Language, Store].each(&:delete_all)

p 'Creating films'
data = CSV.read('lib/data.csv')
data.each do |title, language|
  Film.create(title: title, language: Language.find_or_create_by(name: language))
end

p "Creating 10 stores"

10.times do |i|
  p "Creating store number #{i+1}"
  store = Store.new(id: i+1)
  store.save(validate: false)

  film_ids = Film.pluck(:id)

  attrs = film_ids.map { |film_id| {film_id: film_id, store_id: store.id} }

  Inventory.insert_all attrs
end
