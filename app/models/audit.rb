class Audit < ApplicationRecord
  enum action: [:added, :updated, :removed, :archived, 
    :commented, :imported, :exported, :signed_in, :signed_out]
  enum severity: [:success, :info, :warning, :error ]
  validates :detail, presence: true  
  validates :created_at, presence: true
  validates :guid, length: { is: 36, message: "%{value} length need to be 36" }, allow_nil: true
  validates :table, length: { maximum: 70, message: "%{value} length need to be < 71" }
  validates :field, length: { maximum: 70, message: "%{value} length need to be < 71" }  
end
