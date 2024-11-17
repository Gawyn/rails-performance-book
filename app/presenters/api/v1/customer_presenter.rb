class Api::V1::CustomerPresenter
  def to_json
    {
      id: resource.id,
      name: resource.name,
      rental_counter: resource.rentals_count
    }
  end
end
