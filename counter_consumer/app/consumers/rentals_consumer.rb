# frozen_string_literal: true
class RentalsConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      customer_id = message.payload['rental']['user']
      redis_client.incr("customer_rentals_counter_#{customer_id}")
    end
  end

  private

  def redis_client
    @redis_client ||= Redis.new
  end
end
