class Api::V1::RentalPresenter
  attr_reader :resource

  def initialize(rental)
    @resource = rental
  end

  def to_json
    {
      movie_name: resource.inventory.film.title,
      user: resource.customer_id,
      rental_date: resource.rental_date,
      returnal_date: resource.returnal_date
    }
  end
end
