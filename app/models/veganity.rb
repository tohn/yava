# == Schema Information
#
# Table name: veganities
#
#  id                 :integer          not null, primary key
#  name               :string(255)      not null
#  description        :text
#  image              :string(255)
#  color              :string(255)      not null
#  created_at         :datetime
#  updated_at         :datetime
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Veganity < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  
  has_many :product
  has_many :ingredient
  has_many :inquiry
  has_many :comment
  
  # paperclip image stuff
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  #validates_attachment_content_type :image, :content_type => /^image\/(png|gif|jpg|jpeg)/
  #validates_attachment :image, :size => { :in => 0..500.kilobytes }
  
  # ID of VEGAN in the database (table veganities)
      VEGAN = 1
  # ID of NOT_VEGAN in the database (table veganities)
  NOT_VEGAN = 2
  # ID of UNCERTAIN in the database (table veganities)
  UNCERTAIN = 3
  # ID of UNKNOWN in the database (table veganities)
    UNKNOWN = 4
end
