# == Schema Information
#
# Table name: features
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text
#  user_id     :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Feature < ActiveRecord::Base
	validates :name, presence: true, uniqueness: {case_sensitive: false}

	has_many :label

	has_many :j_product_feature
	has_many :feature, :through => :j_product_feature
end
