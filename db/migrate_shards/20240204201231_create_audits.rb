class CreateAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :audits do |t|
      t.integer :store_id
      t.integer :actor_id
      t.string :actor_type
      t.string :event

      t.timestamps
    end
  end
end
