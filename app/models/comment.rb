# == Schema Information
#
# Table name: comments
#
#  id          :integer          not null, primary key
#  comment     :text             not null
#  user_id     :integer          not null
#  veganity_id :integer          default(4), not null
#  comment_id  :integer
#  product_id  :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Comment < ActiveRecord::Base
	validates :comment, presence: true
	validates :user_id, presence: true
	validates :veganity_id, presence: true
	validates :product_id, presence: true
	validates :comment_id, presence: false
	# uniqueness?

	belongs_to :product
	belongs_to :veganity
	belongs_to :user
#	has_many :ref, class_name: "Comment"
	# - wie referenzieren? notfalls comment in text
	#	umbenennen
end
