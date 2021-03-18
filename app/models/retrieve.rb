class Retrieve < ApplicationRecord
  belongs_to :user
  belongs_to :audit
end
