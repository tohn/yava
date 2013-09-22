# == Schema Information
#
# Table name: packagematerials
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  description        :text
#  http               :string(255)
#  user_id            :integer          not null
#  image              :string(255)
#  abbr               :string(255)
#  code               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Packagematerial < ActiveRecord::Base
	validates :name, presence: true, uniqueness: {case_sensitive: false}
	validates :user_id, presence: true

	belongs_to :user
	has_many :product

	# paperclip image stuff
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
	# http://stackoverflow.com/questions/3181845/validate-attachment-content-type-paperclip
	#validates_attachment_content_type :image, :content_type => /^image\/(png|gif|jpg|jpeg)/
	#validates_attachment :image, :size => { :in => 0..500.kilobytes }

	# return name (with code/abbr)
	def get_name
		if abbr.blank? and code.blank?
			name
		else
			"#{code} / #{abbr} - #{name}"
		end
	end
end
