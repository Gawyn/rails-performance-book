class Rental < ApplicationRecord
  after_create :cache_for_followers
  after_create :generate_create_audit
  after_commit :recalculate_store_rentals
  after_save :recalculate_customer_stats_profile
  after_save :produce_kafka_message

  belongs_to :customer, counter_cache: true
  belongs_to :inventory
  has_one :audit, as: :subject
  has_one :store, through: :inventory
  has_one :film, through: :inventory

  scope :to_be_archived, -> { where("returnal_date < ?", Time.now - 1.year) }

  def self.backfill_audits
    all.each(&:generate_audit)
  end

  def self.archived_rentals_bucket_key(customer_id)
    "archived_rentals_for_user_#{customer_id}"
  end

  def generate_create_audit
    store.generate_audit('Rental creation', self, customer) unless audit
  end

  private

  def cache_for_followers
    customer.followers.each do |follower|
      timeline = Rails.cache.read(follower.timeline_cache_key) || []

      Rails.cache.write(
        follower.timeline_cache_key, timeline.unshift(id)[0..9]
      )
    end
  end

  def recalculate_store_rentals
    store.set_most_rented_film!
  end

  def recalculate_customer_stats_profile
    RecalculateCustomerStatsProfileJob.perform_later(customer_id)
  end

  def produce_kafka_message
    Karafka.producer.produce_sync(
      topic: 'rentals', 
      payload: {
        rental: Api::V1::RentalPresenter.new(self).as_json
      }.to_json
    )
  end
end
