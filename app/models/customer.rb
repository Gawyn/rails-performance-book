class Customer < ApplicationRecord
  has_many :rentals
  has_many :followings, foreign_key: 'follower_id', dependent: :destroy
  has_many :followeds, through: :followings
end
