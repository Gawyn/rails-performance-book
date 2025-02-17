class Customer < ApplicationRecord
  has_many :rentals
  has_many :followings, foreign_key: 'follower_id', dependent: :destroy
  has_many :followeds, through: :followings

  has_many :inverse_followings, foreign_key: 'followed_id', dependent: :destroy, class_name: 'Following'
  has_many :followers, through: :inverse_followings
end
