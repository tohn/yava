# == Schema Information
#
# Table name: classnames
#
#  id         :integer          not null, primary key
#  sg         :string(255)      not null
#  pl         :string(255)      not null
#  abbr       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Classname < ActiveRecord::Base
	validates :sg, presence: true
	validates :pl, presence: true
	validates :abbr, presence: true
	validates_uniqueness_of :sg, :scope => [:pl, :abbr] # {case_sensitive: false}

#	has_many :classname_synonym
#	has_many :synonym, class_name: "ClassnameSynonym"
	
	belongs_to :ingredient
	
	has_many :classname_synonym, class_name: "ClassnameSynonym"

	# Returns singular name (with synonyms)
	def get_sg
		if !classname_synonym.blank?
			sg + ", " + classname_synonym.map do |s|
				s.sg
			end.join(", ")
		else
			sg
		end
	end

	# Returns plural name (with synonyms)
	def get_pl
		if classname_synonym.any?
			pl + ", " + classname_synonym.map do |s|
				s.pl
			end.join(", ")
		else
			pl
		end
	end
	
	# Returns singular name (with synonyms) and abbreviation
	def get_sg_w_abbr
	  abbr+" - "+get_sg
	end

	# Checks if an ingredient is a classname
	def self.contains_this(ingredient)
		tmp = where("lower(sg) like ? or lower(pl) like ?", UnicodeUtils.downcase(ingredient), UnicodeUtils.downcase(ingredient))
		if !tmp.blank?
			return true
		else
			tmp = ClassnameSynonym.contains_this(ingredient)
			if !tmp.blank?
				return true
			end
			return false
		end
	end
end
