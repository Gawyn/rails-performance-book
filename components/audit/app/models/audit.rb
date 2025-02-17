class Audit < ShardRecord
  belongs_to :store
  belongs_to :actor, polymorphic: true
  belongs_to :subject, polymorphic: true
end
