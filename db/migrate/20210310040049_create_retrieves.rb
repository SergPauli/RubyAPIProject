class CreateRetrieves < ActiveRecord::Migration[6.0]
  def change
    create_table :retrieves do |t|
      t.references :user, null: false
      t.references :audit, null: false

      t.timestamps
    end
    add_index :retrieves, [:user_id, :audit_id], unique: true, name: "by_retrieve"
  end
end
