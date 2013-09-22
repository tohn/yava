# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base
	validates :name, presence: true, uniqueness: {case_sensitive: false}

	has_many :products
	has_many :cities
end
