class User < ApplicationRecord
  has_many :subscribes, dependent: :destroy  
  belongs_to :person
  accepts_nested_attributes_for :person
  accepts_nested_attributes_for :subscribes
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable  

  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :confirmable        
end
