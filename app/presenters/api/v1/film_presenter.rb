class Api::V1::FilmPresenter
  attr_reader :resource

  def initialize(film)
    @resource = film
  end

  def to_json
    {
      id: resource.id,
      title: resource.title
    }
  end
end
