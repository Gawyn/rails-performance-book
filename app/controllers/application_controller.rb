class ApplicationController < ActionController::Base
  include CursorBasedPaginationSupport

  private

  def cached_response(expiration_key)
    cache_key = request.path + "###-expiration_key"
    object = Rails.cache.fetch(cache_key)

    object = yield
    object.tap do |object|
      Rails.cache.write(cache_key, object)
    end
  end
end
