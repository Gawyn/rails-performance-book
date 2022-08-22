# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

[Film, Inventory, Language, Store].each(&:destroy_all)

CSV.read('lib/data.csv').each do |title, language|
  Film.create(title: title, language: Language.find_or_create_by(name: language))
end

5.times do |i|
  store = Store.new(id: i+1)
  store.save(validate: false)

  Film.all.each do |film|
    Inventory.create(film: film, store: store)
  end
end
