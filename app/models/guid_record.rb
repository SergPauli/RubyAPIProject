require "securerandom"
class GuidRecord  < ApplicationRecord
  has_many :audits, -> { where(guid: @guid) }

  accepts_nested_attributes_for :audits

  def self.nested_attributes
    return [audits_attributes: [:guid, :action, :table, :field, 
      :detail, :before, :after, :severity, :summary, :user_id, :created_at]]
  end

  def self.nested_select_params 
    return [audits: {except: [:guid]}] 
  end

  before_validation :generate_GUID    
  self.abstract_class = true


  validates :guid, presence: true, length: { is: 36, message: "%{value} length need to be 36" }
  private 
    def generate_GUID
      @guid ||= SecureRandom.uuid      
    end    
end