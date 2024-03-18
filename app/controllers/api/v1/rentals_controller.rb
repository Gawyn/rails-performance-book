class Api::V1::RentalsController < ApplicationController
  def create
    inventory = Inventory.where(film_id: params[:film_id], store_id: params[:store_id]).limit(1).first
    Rental.create(customer_id: params[:customer_id], inventory_id: inventory.id)
  end
end
