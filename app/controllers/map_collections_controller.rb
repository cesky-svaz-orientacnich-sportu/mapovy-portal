# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: map_collections
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  slug              :string(255)
#  description       :text
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

class MapCollectionsController < ApplicationController

  before_action :require_manager, only: [:edit, :create, :update, :new, :destroy]

  def index
    @map_collections = MapCollection.order(:title)
  end

  def new
    @map_collection = MapCollection.new
  end

  def edit
    @map_collection = MapCollection.find(params[:id])
  end

  def show
    @map_collection = MapCollection.find(params[:id])
  end

  def create
    @map_collection = MapCollection.create(params[:map_collection])
    redirect_to :action => :index
  end

  def update
    @map_collection = MapCollection.find(params[:id])
    @map_collection.update(params[:map_collection])
    redirect_to :action => :index
  end

  def destroy
    respond_to do |format|
      format.html do
        redirect_to :action => :index
      end
    end
  end


end
