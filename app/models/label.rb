# == Schema Information
#
# Table name: labels
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  feature_id         :integer          not null
#  image              :string(255)
#  source             :string(255)
#  user_id            :integer          not null
#  description        :text
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Label < ActiveRecord::Base
	validates :name, presence: true, uniqueness: {case_sensitive: false}
#	validates :feature_id, presence => ?
	validates :user_id, presence: true
#	validates :image, presence: true
	
	belongs_to :feature

	has_many :j_product_label
	has_many :product, :through => :j_product_label

	# paperclip image stuff
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
	# http://stackoverflow.com/questions/3181845/validate-attachment-content-type-paperclip
	#validates_attachment_content_type :image, :content_type => /^image\/(png|gif|jpg|jpeg)/
	#validates_attachment :image, :size => { :in => 0..500.kilobytes }

	# TODO: has_many features!
	def g_feature
		if !feature.blank?
			feature.name
		end
	end
end
