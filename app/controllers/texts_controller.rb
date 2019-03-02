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

class TextsController < ApplicationController
  
  before_filter :require_any_user, only: :current_user_page
  
  def current_user_page
    @check_against_oris = current_user.check_against_oris
    current_user.save
    #...
  end
  
  def current_user_edit
  end

  def current_user_update
    current_user.update_attribute(:full_name, params[:full_name])
    redirect_to :current_user_page
  end
  
  def show
    @text = Text.where(:name => params[:name]).first
  end
  
end
