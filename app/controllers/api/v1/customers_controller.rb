class Api::V1::CustomersController < ApplicationController
  def index
    render json: Customer.all.map { |film| Api::V1::CustomerPresenter.new(film).to_json }
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
end
