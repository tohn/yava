# == Schema Information
#
# Table name: providers
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  description :text             not null
#  fullname    :string(255)      not null
#  aktiv       :boolean          default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Provider < ActiveRecord::Base
	validates :name, presence: true, uniqueness: {case_sensitive: false}
	validates :fullname, presence: true, uniqueness: {case_sensitive: false}

	has_many :users
end
