class RentalsArchivalJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rental.to_be_archived.each do |rental|
      redis_client.rpush(
        Rental.archived_rentals_bucket_key(rental.customer_id),
        rental.attributes
      )

      rental.delete
    end
  end

  private

  def redis_client
    @redis_client ||= Redis.new
  end
end
