class Rental < ApplicationRecord
  after_create :cache_for_followers
  belongs_to :customer
  belongs_to :inventory
  has_one :store, through: :inventory
  has_one :film, through: :inventory

  private

  def cache_for_followers
    customer.followers.each do |follower|
      timeline = Rails.cache.fetch(follower.timeline_cache_key) || []

      Rails.cache.write(follower.timeline_cache_key, timeline.append(id))
    end
  end
end
