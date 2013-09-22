# == Schema Information
#
# Table name: inquiries
#
#  id          :integer          not null, primary key
#  typ         :boolean          default(FALSE), not null
#  text        :text             not null
#  user_id     :integer          not null
#  highlight   :boolean          default(FALSE), not null
#  veganity_id :integer          default(4), not null
#  product_id  :integer          not null
#  seen        :boolean          default(FALSE), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Inquiry < ActiveRecord::Base
	validates :text, presence: true
	validates :user_id, presence: true
	validates :veganity_id, presence: true
	validates :product_id, presence: true

	# uniqueness: text, scope: product, type?
	
	belongs_to :product
	belongs_to :veganity
	belongs_to :user
end
