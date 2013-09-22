# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  postcode   :integer
#  name       :string(255)
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class City < ActiveRecord::Base
	validates :postcode, presence: true
	validates :name, presence: true
	validates :country_id, presence: true
	validates_uniqueness_of :postcode, :scope => [:name, :country_id] # {case_sensitive: false}

	has_many :manufacturers
	belongs_to :country

	# return "postcode cityname, countryname" if country is given
	def address
		if !country_id.blank?
			"#{postcode} #{name}, #{country.name}"
		end
	end
end
