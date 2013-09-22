# == Schema Information
#
# Table name: emailhashes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  salt       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Emailhash < ActiveRecord::Base
  validates :user_id, presence: true
  validates :salt, presence: true

  belongs_to :user
end
