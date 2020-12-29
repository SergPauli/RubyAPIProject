class Person < ApplicationRecord
  has_many :contacts, dependent: :destroy
  def full_name
    result = middlename ?  middlename+" " : ""
    result = surname+" "+ result + name
  end  
end
