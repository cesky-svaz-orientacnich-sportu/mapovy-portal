# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: clubs
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  abbreviation   :string(255)
#  region         :string(255)
#  district       :string(255)
#  url            :string(255)
#  division       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  oris_data_json :text
#  slug           :string(255)
#

class ClubsController < ApplicationController
  
  def index
    respond_to do |format|
      format.html
      format.json { render json: ClubsDatatable.new(view_context) }
    end
  end
  
  
  def show
    @club = Club.find(params[:id])
  end
  
end
