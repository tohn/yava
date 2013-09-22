# == Schema Information
#
# Table name: ingredients
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  description        :text
#  veganity_id        :integer          default(4), not null
#  image              :string(255)
#  source             :string(255)
#  user_id            :integer          not null
#  hide               :boolean          default(FALSE), not null
#  fixed              :boolean          default(FALSE), not null
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Ingredient < ActiveRecord::Base
  before_save { self.name = UnicodeUtils.downcase(self.name) }
	validates :name, presence: true, uniqueness: {case_sensitive: false}
	validates :veganity_id, presence: true
	validates :user_id, presence: true
	validates :hide, :inclusion => { :in => [true, false] }

	has_many :j_product_ingredient
	has_many :products, :through => :j_product_ingredient #, foreign_key: :product_id, class_name: "Product"

#	has_many :products, class_name: "Product"
	has_many :j_ingredient_product
	has_many :product, :through => :j_ingredient_product
	
#	has_many :classname
	
	has_many :ingredient_synonym
	
	belongs_to :veganity
	belongs_to :user
	
	has_many :j_ingredient_classname
	has_many :classname, :through => :j_ingredient_classname

	# paperclip image stuff
	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
	# http://stackoverflow.com/questions/3181845/validate-attachment-content-type-paperclip
	#validates_attachment_content_type :image, :content_type => /^image\/(png|gif|jpg|jpeg)/
	#validates_attachment :image, :size => { :in => 0..500.kilobytes }

	# return all names (with synonyms)
	def get_names
	  if !ingredient_synonym.blank?
	    UnicodeUtils.titlecase(name) + ", " + ingredient_synonym.map do |i|
	      UnicodeUtils.titlecase(i.name)
	    end.join(", ")
	  else
	    UnicodeUtils.titlecase(name)
	  end
	end
	
	# return all synonyms
	def get_synonyms
	  if !ingredient_synonym.blank?
	    ingredient_synonym.map do |i|
	      UnicodeUtils.titlecase(i.name)
	    end.join(", ")
	  end
	end
	
	# return all classnames
	def get_classnames
	  if classname.any?
	    classname.map do |c|
	      c.get_sg
	    end.join(", ")
	  end
	end
	
	# compute the veganity of an array which contains the veganities of the products which contain only this ingredient
	def compute_veganity(arr)
		# vegan + not vegan = uncertain
		if arr.include?(Veganity::VEGAN) and arr.include?(Veganity::NOT_VEGAN)
		  Veganity::UNCERTAIN
		elsif arr.include?(Veganity::UNCERTAIN)
		  Veganity::UNCERTAIN
		# not vegan
		elsif arr.include?(Veganity::NOT_VEGAN)
		  Veganity::NOT_VEGAN
		# vegan
		elsif arr.include?(Veganity::VEGAN)
		  Veganity::VEGAN
		# unknown
		else
		  Veganity::UNKNOWN
		end
	end

	# calculate the veganity of this ingredient by using an array and compute_veganity
	def update_veganity
	  arr = []
	  # products which contain only this ingredient = product
	  self.product.map do |p|
	    # TODO: contains the old veganities (not updated, at most one hour old)
	    arr << p.veganity_id
	  end
	  #veganity_id
	  #j_ingredient_product.map do |p|
	  #	p.update(veganity)
	  #if !self.fixed
	    #self.update(veganity_id: compute_veganity(arr))
	  #end
	  if self.fixed
	    self.veganity_id
	  else
	    if arr.any?
	      logger.debug arr
	      compute_veganity(arr)
	    else
	      Veganity::UNKNOWN
	    end
	  end
	end
end
