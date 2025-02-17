class Api::V1::StorePresenter
  attr_reader :resource

  def initialize(store)
    @resource = store
  end

  def to_json
    body = {
      id: resource.id,
      title: resource.name,
      most_rented_film: Api::V1::FilmPresenter.new(resource.most_rented_film).to_json
    }

    if Flipper.enabled?(:inventory_count_in_store_presenter, resource)
      body[:inventory_count] = resource.inventories.count
    end

    body
  end
end
