# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :set_locale

  layout "public"

  protected

  def use_map
    @_use_map = true
  end

  def set_locale
    if params[:locale] and params[:locale] != 'undefined' and !current_user
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options(options={})
    options.merge({ locale: I18n.locale })
  end

  def require_any_user
    if current_user
      true
    else
      puts "Current user is false!? #{current_user.inspect}"
      flash.keep
      redirect_to new_user_session_path
    end
  end

  def admin?
    current_user && current_user.admin?
  end

  def has_role?(*roles)
    current_user && (admin? || current_user.has_role?(*roles))
  end

  def require_admin
    if admin?
      true
    else
      flash.keep
      if current_user
        redirect_to root_path
      else
        flash[:error] = "ADMIN privileges needed to view this page."
        redirect_to new_user_session_path
      end
    end
  end

  def require_manager
    if has_role?(:manager)
      true
    else
      flash.keep
      if current_user
        redirect_to root_path
      else
        redirect_to new_user_session_path
      end
    end
  end

  def require_cartographer
    if has_role?(:manager, :cartographer)
      true
    else
      flash.keep
      if current_user
        redirect_to root_path
      else
        redirect_to new_user_session_path
      end
    end
  end

  def require_organizer
    if has_role?(:manager, :cartographer, :organizer)
      true
    else
      flash.keep
      if current_user
        redirect_to root_path
      else
        redirect_to new_user_session_path
      end
    end
  end

  def require_contributor
    if has_role?(:manager, :cartographer, :organizer, :contributor)
      true
    else
      flash.keep
      if current_user
        redirect_to root_path
      else
        redirect_to new_user_session_path
      end
    end
  end

  helper_method :admin?, :has_role?


  def after_sign_in_path_for(resource)
    root_path
  end

end
