class Film < ApplicationRecord
  after_save :write_cache

  has_many :inventories
  has_many :stores, through: :inventories
  belongs_to :language

  private

  def write_cache
    # Updates the cache
    Api::V1::FilmPresenter.new(self).to_json
  end
end
