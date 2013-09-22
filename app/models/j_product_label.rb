# == Schema Information
#
# Table name: j_product_labels
#
#  id         :integer          not null, primary key
#  product_id :integer          not null
#  label_id   :integer          not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class JProductLabel < ActiveRecord::Base
	validates :product_id, presence: true
	validates :label_id, presence: true
	validates :user_id, presence: true

	validates_uniqueness_of :product_id, :scope => [:label_id] # {case_sensitive: false}

	belongs_to :label
	belongs_to :product
	belongs_to :user
end
