class Api::V1::StoresController < ApplicationController
  def show
    store = Store.find params['id']
    render json: Api::V1::StorePresenter.new(store).to_json
  end
end
