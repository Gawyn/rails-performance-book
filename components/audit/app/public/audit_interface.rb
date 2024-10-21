class AuditInterface
  def self.create(params)
    Audit.create(params)
  end

  def self.where(params)
    Audit.where(params)
  end
end
