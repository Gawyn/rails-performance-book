class Rental < ApplicationRecord
  after_create :cache_for_followers
  after_create :generate_create_audit
  after_save :produce_kafka_message
  after_save :recalculate_customer_stats_profile

  belongs_to :customer, counter_cache: true
  belongs_to :inventory
  has_one :store, through: :inventory
  has_one :film, through: :inventory

  scope :to_be_archived, -> { where("returnal_date < ?", Time.now - 1.year) }

  def self.archived_rentals_bucket_key(customer_id)
    "archived_rentals_for_user_#{customer_id}"
  end

  private

  def recalculate_customer_stats_profile
    RecalculateCustomerStatsProfileJob.perform_later(customer_id)
  end

  def produce_kafka_message
    Karafka.producer.produce_sync(topic: 'rentals', payload: {rental: Api::V1::RentalPresenter.new(self).as_json}.to_json)
  end

  def cache_for_followers
    follower_ids = Following.where(followed_id: customer_id).pluck(:follower_id)
    Customer.where(id: follower_ids).each do |follower|
      timeline = Rails.cache.fetch(follower.timeline_cache_key) || []

      Rails.cache.write(follower.timeline_cache_key, timeline.append(id))
    end
  end

  def generate_create_audit
    store.generate_audit('Rental creation', customer)
  end
end
