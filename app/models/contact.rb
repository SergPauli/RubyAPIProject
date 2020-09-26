class Contact < ApplicationRecord
  belongs_to :person
  regex = '/\A[a-zA-Z]+\z/'
  message = 'only allows letters'
  validates :data, presence: true, format: { with: regex,
    message:  message}
end
