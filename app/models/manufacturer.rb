# == Schema Information
#
# Table name: manufacturers
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  street             :string(255)
#  city_id            :integer
#  http               :string(255)
#  email              :string(255)
#  tel                :string(255)
#  fax                :string(255)
#  image              :string(255)
#  user_id            :integer          not null
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Manufacturer < ActiveRecord::Base
	validates :name, presence: true
#	validates uniqueness :name, scope: city_id

#	has_many :j_manufacturer_brands
	has_many :brands #, :through => :j_manufacturer_brands

	# http://railscasts.com/episodes/196-nested-model-form-part-1
#	accepts_nested_attributes_for :brands, :reject_if => lambda {|a| a[:name].blank?}

#	has_many :brands
	belongs_to :city
	belongs_to :user
	# unique name?
	
	# paperclip image stuff
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
	# http://stackoverflow.com/questions/3181845/validate-attachment-content-type-paperclip
	#validates_attachment_content_type :image, :content_type => /^image\/(png|gif|jpg|jpeg)/
	#validates_attachment :image, :size => { :in => 0..500.kilobytes }

	# return address (street<br>city.address)
	# TODO no html!
	def address
		if !city.blank? and !city.country.blank?
		  # TODO no html!
		  "#{street}<br>#{city.address}".html_safe
		else
		  street
		end
	end

	# return brands
	def get_brands
		brands.map do |b|
			b.name
		end.join(", ")
	end
end
