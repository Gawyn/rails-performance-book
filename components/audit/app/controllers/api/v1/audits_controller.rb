class Api::V1::AuditsController < ApplicationController
  def index
    store = Store.find(params[:store_id])
    Datadog::Tracing.trace('audits.fetch') do
      @audits = Audit.where(store_id: params[:store_id]).all
    end
    render json: @audits.map { |audit| Api::V1::AuditPresenter.new(audit).to_json }
  end
end
