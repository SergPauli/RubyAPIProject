class Contact < ApplicationRecord
  belongs_to :person
  #REGEX = "\A[a-zA-Z]+\z"
  #MESSAGE = "only allows letters"
  validates :data, presence: true
  #, format: { with: /REGEX/,  message:  MESSAGE}
end
