class Api::V1::Presenter
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def to_json(exclude: [])
    Datadog::Tracing.trace('presenter.to_json', service: 'presentation-layer', resource: resource&.class&.to_s) do
      return nil unless resource

      json_object = cached_object

      exclude.each do |excluded_attr|
        json_object.delete(excluded_attr)
      end

      json_object
    end
  end

  private

  def cached_object
    cached_object ||= begin
      object = Rails.cache.fetch(cache_key)

      return object.tap { |h| h.delete(:expiration_key) } if object && object[:expiration_key] == expiration_key

      as_json.merge(expiration_key: expiration_key).tap do |object|
        Rails.cache.write(cache_key, object)
        object.delete(:expiration_key)
      end
    end
  end

  def cache_key
    "#{resource.class}-#{resource.id}"
  end
end
