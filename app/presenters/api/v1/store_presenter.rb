class Api::V1::StorePresenter
  attr_reader :resource

  def initialize(store)
    @resource = store
  end

  def to_json
    {
      id: resource.id,
      name: resource.name,
      most_rented_film: Api::V1::FilmPresenter.new(resource.most_rented_film).to_json
    }
  end
end
