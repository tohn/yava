# == Schema Information
#
# Table name: products
#
#  id                      :integer          not null, primary key
#  gtin                    :integer          not null
#  image                   :string(255)
#  name                    :string(255)      not null
#  description             :text
#  category_id             :integer
#  nutval_id               :integer
#  packagematerial_id      :integer
#  packagesize             :string(255)
#  country_id              :integer
#  brand_id                :integer
#  veganity_ingredients_id :integer          default(4), not null
#  veganity_inquiries_id   :integer          default(4), not null
#  veganity_comments_id    :integer          default(4), not null
#  veganity_source_id      :integer          default(4), not null
#  veganity_id             :integer          default(4), not null
#  source                  :string(255)
#  integrity               :integer
#  user_id                 :integer          not null
#  up_user_id              :integer
#  ingredients             :text
#  created_at              :datetime
#  updated_at              :datetime
#  image_file_name         :string(255)
#  image_content_type      :string(255)
#  image_file_size         :integer
#  image_updated_at        :datetime
#  traces                  :text
#  contains                :text
#

class Product < ActiveRecord::Base
  validates :gtin, presence: true, uniqueness: {case_sensitive: false}, length: {
    minimum: 8,
    maximum: 14,
    }, numericality: { 
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 99999999999999
    }
  validates :user_id, presence: true
  validates :name, presence: true
  
  # paperclip image stuff
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  # http://stackoverflow.com/questions/3181845/validate-attachment-content-type-paperclip
  #validates_attachment_content_type :image, :content_type => /^image\/(png|gif|jpg|jpeg)/
  #	validates_attachment_size :image, :size => { :in => 0..500.kilobytes }
  #validates_attachment :image, :size => { :in => 0..500.kilobytes }
  
  #	validates_presence_of :source, :scope => [:veganity_source_id]
  
  belongs_to :user
  belongs_to :up_user, class_name: "User"
  belongs_to :country
  belongs_to :brand
  # http://stackoverflow.com/questions/1163032/rails-has-many-with-alias-name
  belongs_to :veganity_ingredients, class_name: "Veganity"
  belongs_to :veganity_inquiries, class_name: "Veganity"
  belongs_to :veganity_comments, class_name: "Veganity"
  belongs_to :veganity_source, class_name: "Veganity"
  belongs_to :veganity
  #	belongs_to :veganity_features, class_name: "Veganity"
  # veganity? TODO => remove/modify helper method?
  
  has_many :j_product_ingredient
  has_many :ingredient, :through => :j_product_ingredient
  #, source: :product_id, class_name: "Ingredient"
  #	belongs_to :ingredient, class_name: "Ingredient"
  
  #	has_many :j_ingredient_product
  #	has_many :ingredient, :through => :j_ingredient_product
  
  has_many :j_product_label
  has_many :label, :through => :j_product_label
  
  has_many :j_product_feature
  has_many :feature, :through => :j_product_feature
  
  #	has_one :nutval
  belongs_to :nutval
  
  has_many :comments
  has_many :inquiries
  
  belongs_to :packagematerial
  belongs_to :category, class_name: "Subcategory"
  
  # Return country name if country_id is given
  def get_country_name
    if !country_id.blank?
      country.name
    end
  end
  
  # update the veganity of a product
  # use only 2 or 3 factors
  # 2 if the product is also an ingredient (it has only one ingredient)
  # 3 if the product has more than one ingredient
  def update_veganity
    tmp = true
    if self.ingredient.count == 0
      arr = [veganity_ingredients_id, veganity_inquiries_id, veganity_comments_id]
    elsif self.ingredient.count == 1
      if self.ingredient.first.fixed
	self.update(veganity_ingredients_id: self.ingredient.first.veganity_id)
	arr = [veganity_ingredients_id, veganity_inquiries_id, veganity_comments_id]
      else
	arr = [veganity_inquiries_id, veganity_comments_id]
	tmp = false
      end
    else
      arr = []
      self.ingredient.where("not hide").map do |i|
	arr << i.veganity_id
      end
      self.update(veganity_ingredients_id: compute_overall_ingredients_veganity(arr))
      arr = [veganity_ingredients_id, veganity_inquiries_id, veganity_comments_id]
    end
    
    # if source/inquiries/comments == vegan and ingredients != not_vegan then remove ingredients
    if tmp # ignore the array without veganity_ingredients_id
      if veganity_ingredients_id != Veganity::NOT_VEGAN and (veganity_inquiries_id == Veganity::VEGAN or veganity_comments_id == Veganity::VEGAN)
	# remove only the veganity_ingredients_id (always the first element)
	arr.delete_at(0)
      end
    end
    
    if arr.include?(Veganity::NOT_VEGAN)
      Veganity::NOT_VEGAN
    elsif arr.include?(Veganity::UNCERTAIN)
      Veganity::UNCERTAIN
    elsif arr.include?(Veganity::VEGAN)
      Veganity::VEGAN
    else
      Veganity::UNKNOWN
    end
  end
  
  # This computes the overall veganity of the associated ingredients of a product
  #
  # Input: array with veganities (enums)
  #
  # Output: veganity (enum)
  def compute_overall_ingredients_veganity(arr)
    if arr.include?(Veganity::NOT_VEGAN)
      Veganity::NOT_VEGAN
    elsif arr.include?(Veganity::UNKNOWN)
      Veganity::UNKNOWN
    elsif arr.include?(Veganity::UNCERTAIN)
      Veganity::UNCERTAIN
    else
      Veganity::VEGAN
    end
  end
  
  # Returns the integrity of a product
  #--
  # TODO: print, what exactly is missing (e.g. the description)
  #++
  def update_integrity
    @counter = 0
    @counter = 0
    @border = 100
    @quantity = 9.0
    
    # http://stackoverflow.com/questions/4023181/given-a-model-how-to-loop-through-all-properties
    # http://stackoverflow.com/questions/4665574/ruby-on-rails-get-collection-of-attributes-for-a-model
    @rejects = ["id", "image", "created_at", "updated_at", "integrity", "user_id", "up_user_id", "nutval_id", "label", "source", "feature", "contains", "traces", "veganity_ingredients_id", "veganity_inquiries_id", "veganity_comments_id", "veganity_source_id", "veganity_id", "image_file_name", "image_content_type", "image_file_size", "image_updated_at"]
    #@required = ["gtin", "name", "description", "category_id", 
    #"packagematerial_id", "packagesize", "country_id", "brand_id", 
    #"ingredients"]
    @attributes = self.attributes.reject { |c| @rejects.include?(c) }
    @attributes.each_pair do |x,y|
      if !y.blank?
	@counter += 1
      end
    end
    # compute integrity
    @integrity_new = (@counter/@quantity*@border).to_i
    # fix integrity
    @integrity_new = @border if @integrity_new > @border
    # return integrity
    @integrity_new
  end
end
