class CreateContactstypes < ActiveRecord::Migration[6.0]
  def change
    create_table :contactstypes, :id => false do |t|
      t.primary_key :id,  :limit => 1
      t.string :name, :limit => 100
      t.string :regex
      t.timestamps
    end
  end
end
