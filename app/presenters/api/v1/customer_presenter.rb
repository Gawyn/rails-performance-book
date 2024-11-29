class Api::V1::CustomerPresenter < Api::V1::Presenter
  private

  def as_json
    {
      id: resource.id,
      name: resource.name,
      rental_counter: resource.rentals_count
    }
  end
end
