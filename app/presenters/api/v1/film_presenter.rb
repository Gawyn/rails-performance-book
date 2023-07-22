class Api::V1::FilmPresenter
  attr_reader :resource

  def initialize(film)
    @resource = film
  end

  def to_json
    return nil unless resource
    {
      id: resource.id,
      title: resource.title
    }
  end
end
