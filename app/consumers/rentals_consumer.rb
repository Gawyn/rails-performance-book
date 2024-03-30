class RentalsConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      customer_id = message.payload['rental']['user']
      CustomerStatsProfile.find_or_create_by(customer_id: customer_id).recalculate!
    end
  end
end
