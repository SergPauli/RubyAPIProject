class Person < ApplicationRecord
  has_many :contacts, dependent: :destroy
  def full_name
    result = middlename ?  middlename+" " : ""
    result = surname+" "+ result + name
  end  
  def as_json(options={})
    super(include: :contacts)
  end
  ransack_alias :text, :name_or_surname_or_middlename_or_description
end
