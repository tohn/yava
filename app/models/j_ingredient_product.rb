# == Schema Information
#
# Table name: j_ingredient_products
#
#  id            :integer          not null, primary key
#  ingredient_id :integer          not null
#  product_id    :integer          not null
#  user_id       :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class JIngredientProduct < ActiveRecord::Base
	validates :ingredient_id, presence: true
	validates :product_id, presence: true
	validates :user_id, presence: true
	validates_uniqueness_of :ingredient_id, :scope => [:product_id] # {case_sensitive: false}

	belongs_to :ingredient #, class_name: "Ingredient"
	belongs_to :product #, class_name: "Product"
	belongs_to :user #, class_name: "User"
end
