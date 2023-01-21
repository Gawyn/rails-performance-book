class Api::V1::CustomerPresenter
  private

  def to_json
    {
      id: resource.id,
      name: resource.name,
      rental_counter: resource.rentals_count
    }
  end
end
