desc 'Seed DD'

def call_url(url)
  Net::HTTP.get(URI(url))
  sleep 1
end

task seed_datadog: :environment do
  while true do
    store_id = Store.ids.sample
    customer_id = Customer.ids.sample

    call_url "http://localhost:3000/api/v1/stores/#{store_id}"
    call_url "http://localhost:3000/api/v1/stores/#{store_id}/audits"
    call_url "http://localhost:3000/api/v1/films"
    call_url "http://localhost:3000/films"
    call_url "http://localhost:3000/customers/#{customer_id}"
  end
end
