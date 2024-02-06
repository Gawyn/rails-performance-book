class Audit < ShardRecord
  belongs_to :store
  belongs_to :actor, polymorphic: true
end
