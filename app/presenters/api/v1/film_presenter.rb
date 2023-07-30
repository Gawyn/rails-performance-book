class Api::V1::FilmPresenter < Api::V1::Presenter
  attr_reader :resource

  def initialize(film)
    @resource = film
  end

  private

  def cache_key
    "Film-#{resource.id}"
  end

  def as_json
    {
      id: resource.id,
      title: resource.title
    }
  end

  def expiration_key
    resource.updated_at
  end
end
