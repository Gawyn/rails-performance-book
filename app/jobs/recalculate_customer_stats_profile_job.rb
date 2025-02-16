class RecalculateCustomerStatsProfileJob < ApplicationJob
  queue_as :low_priority

  def perform(customer_id)
    CustomerStatsProfile.find_or_create_by(customer_id: customer_id)
      .recalculate!
  end
end
