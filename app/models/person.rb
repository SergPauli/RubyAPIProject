class Person < ApplicationRecord
  has_many :contacts, ->{ select(:id, :person_id, :data, :description, :type) }, dependent: :destroy  
  has_many :emails
  has_many :phones
  has_many :faxes
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
    return [contacts: {only: [:id, :data, :description, :type]}] 
  end  

  def full_name
    result = middlename ?  middlename+" " : ""
    result = surname+" "+ result + name
    return result
  end 

  # def as_json(options={})
  #   contacts_arr = Array.new     
  #   result = super(options) 
  #   contacts.each do |contact|      
  #     contacts_arr.push(contact.as_json(only: [:id, :data, :type]))      
  #   end  
  #   #, :phone_ids=>phone_ids, :email_ids=>email_ids  
  #   return result.merge({:contacts =>contacts_arr}) 
  # end     
  ransack_alias :text, :name_or_surname_or_middlename_or_description
end
