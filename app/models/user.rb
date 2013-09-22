# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  provider_id    :integer          not null
#  uid            :string(255)      not null
#  name           :string(255)      not null
#  nickname       :string(255)      not null
#  email          :string(255)      not null
#  lastlogin      :datetime         not null
#  lastaction     :datetime         not null
#  permission_id  :integer          default(0), not null
#  points         :integer          default(0), not null
#  email_verified :boolean          default(FALSE), not null
#  anonymize_name :boolean          default(FALSE), not null
#  created_at     :datetime
#  updated_at     :datetime
#  first_mail     :boolean          default(FALSE), not null
#

class User < ActiveRecord::Base
  validates :name, presence: true
  validates :nickname, presence: true, uniqueness: {case_sensitive: false}
  
  validates :provider_id, presence: true
  validates :uid, presence: true
  validates_uniqueness_of :uid, :scope => [:provider_id]
  
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  
  has_many :products
  has_many :ingredients
  has_many :inquiries
  has_many :comments
  
  has_many :j_product_ingredient
  has_many :j_manufacturer_brand
  #	has_many :j_ingredient_product
  has_many :j_product_label
  has_many :j_product_feature
  
  has_many :product, :through => :j_product_ingredient
  has_many :ingredient, :through => :j_product_ingredient
  has_many :label, :through => :j_product_label
  has_many :feature, :through => :j_product_feature
  
  #	has_many :product, :through => :j_ingredient_product
  #	has_many :ingredient, :through => :j_ingredient_product
  
  has_many :manufacturer, :through => :j_manufacturer_brand
  has_many :brand, :through => :j_manufacturer_brand
  
  belongs_to :provider
  
  has_one :emailhash
  
  # search for an user, signin or create (or reactivate)
  def self.from_omniauth(auth)
    # facebooks extrawurst ...
    if UnicodeUtils.downcase(auth["provider"]) == "3" # facebook
      uid = auth["id"].to_s
    else
      uid = auth["uid"].to_s
    end
    
    provid = Provider.find_by_name(auth["provider"].to_s.capitalize) unless auth["provider"].blank?
    tmp = self.where("provider_id = ? and uid = ?", provid.id, uid).first
    
    # udpate lastlogin
    if tmp.blank?
      # search for inactive users
      tmp = self.where("provider_id = ? and uid = ?", provid.id, uid+"d").first
      if tmp.blank?
	create_with_omniauth(auth)
      else
	# activate the user again
	tmp.update(:lastlogin => DateTime.current, :uid => uid.to_s, :permission_id => PERMISSIONS_NONE)
	tmp
      end
    else
      tmp.update(:lastlogin => DateTime.current)
      # "return" user :)
      tmp
    end
  end
  
  #--
  # auth schema in general:
  # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
  #++
  
  # this will create a new user (with info from a provider)
  def self.create_with_omniauth(auth)
    #create! do |user|
    create do |user|
      provid = Provider.find_by_name(auth["provider"].to_s.capitalize) unless auth["provider"].blank?
      user.provider_id = provid.id
      
      if provid.id == "3" # facebook
	user.uid = auth["id"].to_s unless auth["id"].blank?
	user.nickname = auth["username"].to_s unless auth["username"].blank?
      elsif provid.id == "2" # google
	user.uid = auth["uid"].to_s unless auth["uid"].blank?
	user.nickname = auth["info"]["email"].to_s.split("@")[0] unless auth["info"]["email"].blank?
      else
	user.uid = auth["uid"].to_s unless auth["uid"].blank?
	user.nickname = auth["info"]["nickname"].to_s unless auth["info"]["nickname"].blank?
      end
      
      # google does not always provide an username
      user.nickname = "veg" + user.provider_id.to_s + user.uid.to_s if user.nickname.blank?
      
      user.name = auth["info"]["name"].to_s unless auth["info"]["name"].blank?
      user.email = auth["info"]["email"].to_s unless auth["info"]["email"].blank?
      
      # twitter doesn't provide an email address ...
      user.email = user.provider_id.to_s + user.uid.to_s + "@change.me" if user.email.blank?
      
      # github name could be empty
      user.name = "Change Me" if user.name.blank?
      
      user.permission_id = PERMISSIONS_NONE
      user.points = POINTS_INITIAL
      user.lastlogin = DateTime.current
      user.lastaction = DateTime.current
      
      user.email_verified = false
      user.anonymize_name = false
      user.first_mail = false
    end
  end
  
  # Updates the points of an user (and also the permission_id)
  def update_points(point)
    self.update(points: self.points + point)
    if self.points > POINTS_NECESSARY_COMMENT and self.permission_id < PERMISSIONS_COMMENT
      self.update(permission_id: PERMISSIONS_COMMENT)
    elsif self.points > POINTS_NECESSARY_INQUIRY and self.permission_id < PERMISSIONS_INQUIRY
      self.update(permission_id: PERMISSIONS_INQUIRY)
    elsif self.points > POINTS_NECESSARY_INGREDIENT and self.permission_id < PERMISSIONS_INGREDIENT
      self.update(permission_id: PERMISSIONS_INGREDIENT)
    end
  end
  
  # Updates the lastaction field
  def update_lastaction
    self.update(lastaction: DateTime.current)
  end
  
  # Checks lastaction
  #
  # returns false, if user is not allowed to do something
  #
  # true otherwise
  def check_lastaction
    if (Time.now.to_i - self.lastaction.to_time.to_i) < LATENCY
      return false
    else
      return true
    end
  end
  
  # return the difference (lastaction and now) in seconds
  #--
  # TODO: check for negative values
  #++
  def get_lastaction_difference
    diff = LATENCY - (Time.current.to_i - self.lastaction.to_time.to_i)
    diff == 1 ? diff.to_s+t("users_lastaction_second.one") : diff.to_s+t("users_lastaction_second.other")
  end
  
  ## Points
  # Points for a new comment
  POINTS_COMMENT = 5
  # Points for a new product
  POINTS_NEW_PRODUCT = 25
  # Points for a product with integrity == 100
  POINTS_FINISHED_PRODUCT = 10
  # Points for a new inquiry (created in the modal)
  POINTS_NEW_INQUIRY = 10
  # Points for a new response of the manufacturer (created in the normal view)
  POINTS_FINISHED_INQUIRY = 40
  # Points for validating the mailaddress
  POINTS_EMAIL = 10
  # Initial Points
  POINTS_INITIAL = 0
  
  ## Points necessary
  # Points necessary to create a new inquiry
  POINTS_NECESSARY_INQUIRY = 500
  # Points necessary to create a new source
  POINTS_NECESSARY_SOURCE = 500
  # Points necessary to create a new comment
  POINTS_NECESSARY_COMMENT = 250
  # Points necessary to create or change a (new) ingredient (manually)
  POINTS_NECESSARY_INGREDIENT = 1000
  
  ## Permissions
  # Deactivated
  PERMISSIONS_DEACTIVATED = -1
  # No Permissions
  PERMISSIONS_NONE = 0
  # Permission to create an inquiry (and also a response)
  # (including all lower ones)
  PERMISSIONS_INQUIRY = 2
  # Permission to create a source (in the product)
  PERMISSIONS_SOURCE = 2
  # Permission to create a comment (including all lower ones)
  PERMISSIONS_COMMENT = 1
  # Permission to create and modify an ingredient
  # also the fixed value (including all lower ones)
  PERMISSIONS_INGREDIENT = 3
  # Permission to delete stuff (including all lower ones)
  PERMISSIONS_DELETE = 5
  # All permissions
  PERMISSIONS_ADMIN = 10
  
  ## Latency
  # Latency between each product, comment or inquiry
  LATENCY = 10
end
