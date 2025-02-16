class Api::V1::AuditsController < ApplicationController
  def index
    store = Store.find(params[:store_id])
    ShardRecord.connected_to(shard: store.shard) do
      audits = Audit.where(store_id: params[:store_id])
      render json: audits.all.map do |store| 
        Api::V1::AuditPresenter.new(store).to_json
      end
    end
  end
end
