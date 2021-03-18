class CreateAudits < ActiveRecord::Migration[6.0]
  def change
    create_table :audits do |t|
      t.string :guid, :limit => 36
      t.integer :action, :limit => 1
      t.string :table, :limit => 70
      t.string :field, :limit => 70
      t.string :detail
      t.string :before
      t.string :after
      t.integer :severity, :limit => 1
      t.string :summary
      t.references :user
      t.datetime :created_at
    end
  end
end
