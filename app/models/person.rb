class Person < ApplicationRecord
  has_many :contacts, ->{ select(:id, :person_id, :data, :description, :type) }, dependent: :destroy  
  has_many :emails
  has_many :phones
  has_many :faxes
  has_many :users, dependent: :destroy 

  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :emails 
  accepts_nested_attributes_for :phones
  accepts_nested_attributes_for :faxes

  def self.nested_attributes
    return [contacts_attributes: [:id, :data, :description, :_destroy], 
    phones_attributes: [:id, :data, :description], emails_attributes: [:id, :data, :description],
    faxes_attributes: [:id, :data, :description]]
  end 

  def self.nested_select_params
    return [contacts: {only: [:id, :data, :description, :type]}, users: {only: :id}] 
  end  

  def full_name
    result = middlename ?  middlename+" " : ""
    result = surname+" "+ result + name
    return result
  end 

  def to_s
    "{id:"+id.to_s+" "+ full_name+"}"
  end
  
  validates :surname, presence: true  
  validates :name, presence: true

  ransack_alias :text, :name_or_surname_or_middlename_or_description
end
