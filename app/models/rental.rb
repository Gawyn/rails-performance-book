class Rental < ApplicationRecord
  after_create :cache_for_followers

  belongs_to :customer, counter_cache: true
  belongs_to :inventory
  has_one :store, through: :inventory
  has_one :film, through: :inventory

  scope :to_be_archived, -> { where("returnal_date < ?", Time.now - 1.year) }

  def archived_rentals_bucket_key
    "archived_rentals_for_user#{customer_id}"
  end

  private

  def cache_for_followers
    follower_ids = Following.where(followed_id: customer_id).pluck(:follower_id)
    Customer.where(id: follower_ids).each do |follower|
      timeline = Rails.cache.fetch(follower.timeline_cache_key) || []

      Rails.cache.write(follower.timeline_cache_key, timeline.append(id))
    end
  end
end
