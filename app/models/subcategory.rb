# == Schema Information
#
# Table name: subcategories
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  category_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Subcategory < ActiveRecord::Base
	validates :name, presence: true
	validates :category_id, presence: true
	validates_uniqueness_of :name, :scope => [:category_id] # {case_sensitive: false}

	belongs_to :category
	has_many :product
end
