# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: texts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  body_cs    :text
#  body_en    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Text < ActiveRecord::Base

  def to_s
    name.to_s
  end

end
