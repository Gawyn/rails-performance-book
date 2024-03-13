class Store < ApplicationRecord
  include IdentityCache
  cache_index :name

  has_many :inventories
  has_many :films, through: :inventories
  has_many :audits
  belongs_to :most_rented_film, class_name: 'Film'

  def set_most_rented_film!
    update_attribute(:most_rented_film_id, Rental.joins(:inventory).where(inventory: {store_id: id}).group(:film_id).count.max_by { |k, v| v }.last)
  end

  def audits
    ActiveRecord::Base.connected_to(role: :writing, shard: shard) do
      Audit.where(store_id: self.id)
    end
  end

  def generate_audit(event, actor)
    ActiveRecord::Base.connected_to(role: :writing, shard: shard) do
      Audit.create(
        event: event,
        actor: actor,
        store: self
      )
    end
  end

  def shard
    [:shard_one, :shard_two, :shard_three][id%3]
  end
end
