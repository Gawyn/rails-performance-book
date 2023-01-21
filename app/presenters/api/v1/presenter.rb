class Api::V1::Presenter
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def to_json
    cached_object
  end

  private

  def cached_object
    object = Rails.cache.fetch(cache_key)

    return object.tap { |h| h.delete(:expiring_key) } if object && object[:expiring_key] == expiration_key

    as_json.merge(expiring_key: expiration_key).tap do |object|
      Rails.cache.write(cache_key, object)
      object.delete(:expiring_key)
    end
  end

  def cache_key
    "#{resource.class}-#{resource.id}"
  end
end
