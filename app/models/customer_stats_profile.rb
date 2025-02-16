class CustomerStatsProfile < ApplicationRecord
  serialize :data
  belongs_to :customer

  def recalculate!
    update_attribute(
      :data, 
      rentals_by_language: customer.rentals.includes(:film)
        .group(:language_id).count(:id)
    )
  end
end
