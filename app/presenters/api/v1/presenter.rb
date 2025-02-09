class Api::V1::Presenter
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def to_json
    return nil unless resource

    object = Rails.cache.fetch(cache_key)

    if object && object[:expiration_key] == expiration_key
      return object.tap { |h| h.delete(:expiration_key) } 
    end

    as_json.merge(expiration_key: expiration_key).tap do |object|
      Rails.cache.write(cache_key, object)
      object.delete(:expiring_key)
    end
  end

  private

  def cache_key
    "#{resource.class}-#{resource.id}"
  end

  def expiration_key
    p resource
    p resource.class
    resource.updated_at
  end
end
