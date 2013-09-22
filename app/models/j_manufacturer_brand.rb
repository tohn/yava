# == Schema Information
#
# Table name: j_manufacturer_brands
#
#  id              :integer          not null, primary key
#  manufacturer_id :integer          not null
#  brand_id        :integer          not null
#  user_id         :integer          not null
#  created_at      :datetime
#  updated_at      :datetime
#

class JManufacturerBrand < ActiveRecord::Base
  validates :manufacturer_id, presence: true
  validates :brand_id, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :manufacturer_id, :scope => [:brand_id]

  belongs_to :manufacturer #, class_name: "Product"
  belongs_to :brand #, class_name: "Ingredient"
  belongs_to :user #, class_name: "User"
end
