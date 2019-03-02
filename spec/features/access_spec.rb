# -*- encoding : utf-8 -*-

require 'rails_helper'
require_relative './_setup'

RSpec.feature "What can be viewed by whom", type: :feature do
  
  include_context "shared environment"  

  scenario "users can be listed by admin" do
    login_as @admin, scope: :user
    visit backend_users_path    
    within('h1') { expect(page).to have_content "Správa uživatelů" }
  end
  
  scenario "noncompleted maps can be listed by cartographer" do
    login_as @cartographerA, scope: :user
    visit noncompleted_maps_path    
    within('h1') { expect(page).to have_content "Mapy čekající na doplnění údajů po vydání" }
  end
  
  scenario "maps can be checked by manager" do
    login_as @manager, scope: :user
    visit check_maps_path    
    within('h1') { expect(page).to have_content "Kontrola integrity" }
  end

end
