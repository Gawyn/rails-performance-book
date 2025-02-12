class Film < ApplicationRecord
  include IdentityCache

  after_save :write_cache

  has_many :inventories

  has_many :stores, through: :inventories
  has_many :rentals, through: :inventories

  belongs_to :language

  private

  def write_cache
    # Updates the cache
    Api::V1::FilmPresenter.new(self).to_json
  end
end
