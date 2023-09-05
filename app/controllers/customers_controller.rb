class CustomersController < ApplicationController
  def show
    @customer = Customer.find params[:id]
    @rentals = @customer.rentals
      .order(created_at: :desc)
      .includes(inventory: :film)
  end
end
