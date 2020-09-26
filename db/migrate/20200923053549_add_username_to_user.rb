class AddUsernameToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :login, :string
  end
end
