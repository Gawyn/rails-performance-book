class CustomersController < ApplicationController
  def show
    # Test comment
    @customer = Customer.find params[:id]
    @rentals = @customer.rentals
      .order(created_at: :desc)
      .includes(inventory: :film)
  end
end
