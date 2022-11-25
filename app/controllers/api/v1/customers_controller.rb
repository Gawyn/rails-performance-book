class Api::V1::CustomersController < ApplicationController
  def index
    render json: Customer.all.map { |film| Api::V1::CustomerPresenter.new(film).to_json }
  end
end
