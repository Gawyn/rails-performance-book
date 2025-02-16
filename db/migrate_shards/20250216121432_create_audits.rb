class CreateAudits < ActiveRecord::Migration[8.0]
  def change
    create_table :audits do |t|
      t.integer :store_id
      t.integer :actor_id
      t.string :actor_type
      t.integer :subject_id
      t.string :subject_type
      t.string :event

      t.timestamps
    end
  end
end
