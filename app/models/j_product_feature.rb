# == Schema Information
#
# Table name: j_product_features
#
#  id         :integer          not null, primary key
#  product_id :integer          not null
#  feature_id :integer          not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class JProductFeature < ActiveRecord::Base
	validates :product_id, presence: true
	validates :feature_id, presence: true
	validates :user_id, presence: true

	validates_uniqueness_of :product_id, :scope => [:feature_id] # {case_sensitive: false}

	belongs_to :product
	belongs_to :feature
	belongs_to :user
end
