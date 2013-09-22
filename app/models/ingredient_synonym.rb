# == Schema Information
#
# Table name: ingredient_synonyms
#
#  id            :integer          not null, primary key
#  ingredient_id :integer          not null
#  name          :string(255)      not null
#  created_at    :datetime
#  updated_at    :datetime
#

class IngredientSynonym < ActiveRecord::Base
  before_save { self.name = UnicodeUtils.downcase(self.name) }
  
  validates :ingredient_id, presence: true
  validates :name, presence: true
  
  belongs_to :ingredient
end
