class AddPersonRefToContacts < ActiveRecord::Migration[6.0]
  def change
    add_reference :contacts, :person, null: false, foreign_key: true
  end
end
