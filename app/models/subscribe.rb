class Subscribe < ApplicationRecord
  belongs_to :user  
  validates :name, presence: true
  validates :guid, length: { is: 36, message: "%{value} length need to be 36" }
  validates :table, length: { less: 71, message: "%{value} length need to be < 71" }
  validates :field, length: { less: 71, message: "%{value} length need to be < 71" }
end
