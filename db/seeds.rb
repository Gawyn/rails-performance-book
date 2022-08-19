# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


Film.destroy_all
Inventory.destroy_all
Store.destroy_all

Film.create(title: 'Breathless', language: Language.create(name: 'french'))
Film.create(title: 'Ordet', language: Language.create(name: 'danish'))
Film.create(title: 'Imitation of Life', language: Language.create(name: 'english'))

5.times do |i|
  store = Store.new(id: i+1)
  store.save(validate: false)

  Film.all.each do |film|
    Inventory.create(film: film, store: store)
  end
end
