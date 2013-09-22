# == Schema Information
#
# Table name: nutvals
#
#  id              :integer          not null, primary key
#  energy          :float
#  proteins        :float
#  carbohydrates   :float
#  sugar           :float
#  fat             :float
#  saturated       :float
#  monounsaturated :float
#  polyunsaturated :float
#  roughages       :float
#  natrium         :float
#  alcohol         :float
#  user_id         :integer          not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Nutval < ActiveRecord::Base
	validates :user_id, presence: true
#	validates :product_id, presence: true

	has_one :product
	belongs_to :user
#	belongs_to :product
end
