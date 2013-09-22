# == Schema Information
#
# Table name: j_product_ingredients
#
#  id            :integer          not null, primary key
#  product_id    :integer          not null
#  ingredient_id :integer          not null
#  user_id       :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#

class JProductIngredient < ActiveRecord::Base
	validates :product_id, presence: true
	validates :ingredient_id, presence: true
	validates :user_id, presence: true
	# http://stackoverflow.com/questions/6012547/validating-uniqueness-of-a-record-in-a-join-table
	validates_uniqueness_of :product_id, :scope => [:ingredient_id] # {case_sensitive: false}

	belongs_to :product #, class_name: "Product"
	belongs_to :ingredient #, class_name: "Ingredient"
	belongs_to :user #, class_name: "User"
end
