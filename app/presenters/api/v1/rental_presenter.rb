class Api::V1::RentalPresenter < Api::V1::Presenter
  attr_reader :resource

  def initialize(rental)
    @resource = rental
  end

  def as_json
    {
      movie_name: resource.inventory.film.title,
      user: resource.customer_id,
      rental_date: resource.rental_date,
      returnal_date: resource.returnal_date
    }
  end

  private

  def expiration_key
    resource.updated_at
  end
end
