# == Schema Information
#
# Table name: brands
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  manufacturer_id :integer          not null
#  user_id         :integer          not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Brand < ActiveRecord::Base
	validates :name, presence: true
	validates :manufacturer_id, presence: true
	validates_uniqueness_of :name, :scope => [:manufacturer_id] # {case_sensitive: false}

	belongs_to :manufacturer
	#has_many :j_manufacturer_brands
	#has_many :manufacturers, :through => :j_manufacturer_brands
	
	has_many :products

	# return brand and manufacturer in brackets
	def brandmanu
		if !manufacturer.name.blank?
			"#{name} (#{manufacturer.name})"
		end
	end
end
