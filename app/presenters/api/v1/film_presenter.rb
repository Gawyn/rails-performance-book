class Api::V1::FilmPresenter
  attr_reader :resource

  def initialize(film)
    @resource = film
  end

  def to_json
    cached_object
  end

  private

  def cached_object
    object = Rails.cache.fetch(cache_key)

    return object.tap { |h| h.delete(:expiring_key) } if object && object[:expiring_key] = resource.updated_at

    jsonize.merge(expiring_key: resource.updated_at).tap do |object|
      Rails.cache.write(cache_key, object)
    )
    end
  end

  def cache_key
    "Film-#{resource.id}"
  end

  def jsonize
    {
      id: resource.id,
      title: resource.title
    }
  end
end
