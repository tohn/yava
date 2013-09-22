# == Schema Information
#
# Table name: classname_synonyms
#
#  id           :integer          not null, primary key
#  classname_id :integer          not null
#  sg           :string(255)      not null
#  pl           :string(255)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

class ClassnameSynonym < ActiveRecord::Base
	validates :classname_id, presence: true
	validates :sg, presence: true
	validates :pl, presence: true
	validates_uniqueness_of :classname_id, :scope => [:sg, :pl] # {case_sensitive: false}

	belongs_to :classname

	# check if TODO
	def self.contains_this(ingredient)
		tmp = where("lower(sg) like ? or lower(pl) like ?", UnicodeUtils.downcase(ingredient), UnicodeUtils.downcase(ingredient))
		if !tmp.blank?
			return true
		else
			return false
		end
	end
end
