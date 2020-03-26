# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: cartographers
#
#  id         :integer          not null, primary key
#  map_id     :integer
#  author_id  :integer
#  role       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Cartographer < ApplicationRecord

  belongs_to :map
  belongs_to :author

  CARTOGRAPHER_ROLES = %w{M K G V R D Z F J}

end


