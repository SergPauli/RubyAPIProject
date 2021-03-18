class AddJobToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :job, :string
    add_column :users, :member, :string    
  end
end
