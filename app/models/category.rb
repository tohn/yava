# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
	validates :name, presence: true, uniqueness: {case_sensitive: false}

#	has_one :category_id, as: "Category"
#	belongs_to :category #, as: "Category"
#	belongs_to :category
#	belongs_to :product
	has_many :subcategory
end
