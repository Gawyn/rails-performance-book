class Api::V1::CustomersController < ApplicationController
  def index
    render json: Customer.all.map { |c| Api::V1::CustomerPresenter.new(c).to_json }
  end

  def timeline
    customer = Customer.find(params[:customer_id])
    rentals = Rental.where(id: Rails.cache.read(customer.timeline_cache_key))
    render json: rentals.map do |rental| 
      Api::V1::RentalPresenter.new(rental).to_json
    end
  end

  def rentals
    @customer = Customer.find params[:customer_id]
    render json: @customer.rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
  end

  def archived_rentals
    key = Rental.archived_rentals_bucket_key(params[:customer_id])
    if redis_client.exists? key
      rentals = redis_client.lrange(key, 0, -1).map do |archived_rental|
        Rental.new(JSON.parse(archived_rental))
      end

      render json: rentals.map { |rental| Api::V1::RentalPresenter.new(rental).to_json }
    else
      render json: []
    end
  end

  private

  def redis_client
    @redis_client ||= Redis.new
  end
end
