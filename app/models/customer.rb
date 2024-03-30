class Customer < ApplicationRecord
  has_many :rentals
  has_many :followings, foreign_key: 'follower_id', dependent: :destroy
  has_many :followeds, through: :followings
  has_one :customer_stats_profile

  def timeline_cache_key
    @timeline_cache_key ||= "rental-timeline-##{id}"
  end
end
