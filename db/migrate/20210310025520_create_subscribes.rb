class CreateSubscribes < ActiveRecord::Migration[6.0]
  def change
    create_table :subscribes do |t|
      t.references :user
      t.string :name 
      t.string :guid, :limit => 36
      t.integer :action, :limit => 1
      t.string :table, :limit => 70
      t.string :field, :limit => 70
      t.integer :severity, :limit => 1
      t.integer :life, :limit => 2
      t.string :summary
      t.boolean :active

      t.timestamps
    end
  end
end
