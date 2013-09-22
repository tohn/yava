# == Schema Information
#
# Table name: j_ingredient_classnames
#
#  id            :integer          not null, primary key
#  ingredient_id :integer          not null
#  classname_id  :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class JIngredientClassname < ActiveRecord::Base
  validates :ingredient_id, presence: true
  validates :classname_id, presence: true
  validates_uniqueness_of :ingredient_id, :scope => [:classname_id]
  
  belongs_to :ingredient
  belongs_to :classname
end
