# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: authors
#
#  id            :integer          not null, primary key
#  note          :string(255)
#  full_name     :string(255)
#  club          :text
#  activity      :string(255)
#  year_of_birth :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class AuthorsController < ApplicationController
  
  before_filter :require_manager, only: [:edit, :update, :destroy]
  
  def index
    respond_to do |format|
      format.html
      format.json { render json: AuthorsDatatable.new(view_context) }
    end
  end
  
  def show
    @author = Author.find(params[:id])
  end
  
  def edit
    @author = Author.find(params[:id])
  end

  def update
    @author = Author.find(params[:id])
    @author.update_attributes(params[:author])
    redirect_to :action => :index
  end

  def destroy
    @author = Author.find(params[:id])
    @author.destroy
    respond_to do |format|
      format.html do
        redirect_to :action => :index
      end
    end
  end    
  
  def merge
    @author = Author.find(params[:id])
    @other_author = Author.find(params[:target_author_id])
    
    @author.cartographers.each do |c|
      if c.author_id == @author.id
        c.update_attribute :author_id, @other_author.id
      end
    end
    @other_author.update_activity
    
    @author.reload
    @author.destroy
    respond_to do |format|
      format.html do
        redirect_to @other_author
      end
    end
  end
  
end
