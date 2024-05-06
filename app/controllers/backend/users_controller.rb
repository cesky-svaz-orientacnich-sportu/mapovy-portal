# -*- encoding : utf-8 -*-
class Backend::UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users = User.order(:name)
  end

  def edit
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @check_against_oris = @user.check_against_oris
    @user.save
  end

  def update
    @user = User.find(params[:id])
    params[:user][:above_role_authorizations].reject!(&:blank?)
    @user.update(params[:user])
    redirect_to [:backend, @user]
  end

  def become
    #return unless current_user.admin?
    sign_in(:user, User.find(params[:id]))
    redirect_to root_url
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html do
        redirect_to :action => :index
      end
    end
  end

end
