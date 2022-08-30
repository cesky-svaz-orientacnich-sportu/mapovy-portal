# -*- encoding : utf-8 -*-
module ApplicationHelper

  def flex(n, s1, s4, sX)
    if n <= 1
      s1
    elsif n <= 4
      s4
    else
      sX
    end
  end

  def _map_collection_path(*params)
    locale = I18n.locale
    if locale == :cs
      cs_map_collection_path(*params)
    else
      en_map_collection_path(*params)
    end
  end

  def _map_path(*params)
    locale = I18n.locale
    if locale == :cs
      cs_map_path(*params)
    else
      en_map_path(*params)
    end
  end

  def text(name)
    if txt = Text.where(:name => name.to_s).first
      RedCloth.new(txt.send(:"body_#{I18n.locale}")).to_html.html_safe
    else
      "?"
    end
  end

  def admin?
    current_user and current_user.admin?
  end

  def icon(klass, options = {})
    attrs = {:class => "fa fa-#{klass}"}
    if color = options.delete(:color)
      attrs[:style] = "color: #{color}"
    end
    if tooltip = options.delete(:tooltip)
      attrs[:"data-toggle"] = "tooltip"
      attrs[:"data-title"] = tooltip
      if tp = options.delete(:tooltip_placement)
        attrs[:"data-placement"] = tp
      end
    end
    if popover = options.delete(:popover)
      attrs[:"data-toggle"] = "popover"
      attrs[:"data-placement"] = 'left'
      attrs[:"data-content"] = "<div style='min-width:220px;font-size:10px'>#{popover}</div>".html_safe
      attrs[:"data-html"] = "true"
      if tp = options.delete(:popover_placement)
        attrs[:"data-placement"] = tp
      end
      if tp = options.delete(:popover_trigger)
        attrs[:"data-trigger"] = tp
      end
    end
    content_tag(:i, "", attrs.merge(options))
  end

  def login_button(p)
    if p == 'facebook'
      image_tag('facebook.png')
    elsif p == 'google' or p == 'google_oauth2'
      image_tag('google.png')
    else
      "Sign in with #{p.titleize}"
    end
  end

  def bool(x, style = :icon, options = {})
    case style
    when :text
      x ? "Ano" : "Ne"
    when :icon
      x ? icon('check', options) : icon('times', options)
    end
  end

  def link(x)
    link_to x, x
  end

  def print_user(u, w_email = false)
    if u
      tt = "ID: #{u.id}"
      tt += " / role: #{I18n.t("roles.#{u.role}")}" if u.role
      tt += " / vydavatelé: #{u.clubs * " + "}" unless u.clubs.blank?
      tt += " / kraje: #{u.regions * " + "}" unless u.regions.blank?
      (u.name.html_safe + " ".html_safe + icon('info-circle', tooltip: tt) + "&nbsp;".html_safe + (w_email ? mail_to(u.email, icon('envelope', tooltip: u.email)) : "")).html_safe
    else
      "---"
    end
  end

  def print_user_tooltip(u)
    if u
      tt = "ID: #{u.id}"
      tt += " / role: #{I18n.t("roles.#{u.role}")}" if u.role
      tt += " / vydavatelé: #{u.clubs * " + "}" unless u.clubs.blank?
      tt += " / kraje: #{u.regions * " + "}" unless u.regions.blank?
      icon('info-circle', tooltip: tt).html_safe
    end
  end

end
