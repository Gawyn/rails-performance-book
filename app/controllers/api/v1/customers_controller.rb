class Api::V1::CustomersController < ApplicationController
  def index
    render json: Customer.all.map { |film| Api::V1::CustomerPresenter.new(film).to_json }
  end

  def timeline
    customer = Customer.find(params[:customer_id])
    rentals = Rental.where(customer_id: customer.followings.pluck(:followed_id))
      .order(created_at: :desc).limit(10)
      .includes(inventory: :film)

    render json: rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  def rentals
    @customer = Customer.find params[:customer_id]
    render json: @customer.rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  def archived_rentals
    rentals = redis_client.fetch(Rental.archived_rentals_bucket_key(params[:customer_id])).map do |params|
      Rental.new(params)
    end

    render json: rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  private

  def redis_client
    @redis_client ||= Redis.new
  end
end
