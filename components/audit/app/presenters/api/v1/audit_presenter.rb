class Api::V1::AuditPresenter < Api::V1::Presenter
  def to_json
    {
      id: resource.id,
      created_at: resource.created_at,
      event: resource.event,
      store_id: resource.id
    }
  end
end
