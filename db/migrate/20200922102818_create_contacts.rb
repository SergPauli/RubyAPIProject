class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :type
      t.string :data
      t.text :description
      t.timestamps
    end
  end
end
