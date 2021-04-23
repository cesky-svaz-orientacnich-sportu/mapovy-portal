Mapserver::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks", :registrations => "registrations", :sessions => "sessions" }

  devise_scope :user do
    post '/users/auth/:provider' => 'omniauth_callbacks#passthru'
  end

  get '/files/maps/*anything', to: redirect("/404", status: 404)

  root :to => 'map#index'

  get '/info/after_sign_up' => "texts#show", name: "#after_sign_up"
  get '/privacy' => "texts#show", name: "privacy"

  get '/convergence/calculator' => "map#convergence_calculator"

  get '/api/oris/:id' => "api#oris_by_id"
  get '/api/oris' => "api#oris"
  get '/api/list' => "api#list"
  get '/api/maps_in_point' => "api#maps_in_point"
  get '/api/select' => "api#select"

  get '/filter_oris_events/:year' => "maps#filter_oris_events"

  get '/mapa/:id' => "maps#show", locale: 'cs', as: :cs_map
  get '/mapy/:id' => "map_collections#show", locale: 'cs', as: :cs_map_collection
  get '/map/:id' => "maps#show", locale: 'en', as: :en_map
  get '/map_collections/:id' => "map_collections#show", locale: 'en', as: :en_map_collection

  scope "/:locale" do

    get '/info/user/edit' => "texts#current_user_edit", as: :edit_current_user_page
    post '/info/user/edit' => "texts#current_user_update"
    get '/info/user' => "texts#current_user_page", as: :current_user_page

    get '/text/:name' => 'texts#show', :as => :text

    get '/convergence' => 'map#convergence', :as => :convergence

    get '/map_browser' => 'map#index', :as => :maps_map
    get '/map_browser/club/:id' => 'map#club', :as => :map_by_club
    get '/map_browser/author/:id' => 'map#author', :as => :map_by_author
    get '/map_browser/collection/:id' => 'map#collection', :as => :map_by_collection
    get '/map_browser/map/:id' => 'map#show', :as => :map_in_map

    resources :maps do
      collection do
        get :all_areas
        get :check
        get :register
        put :register
        patch :register
        post :register
        get "by_user/:user_id" => "maps#by_user", as: :by_user
        get "filed(/:year)" => "maps#filed", as: :filed
        get :download_search
        get :download_all
        get :table_search
        get :check_kml
        get :check_jpg
        get :compare
        get :proposed
        get :completed
        get :noncompleted
        get :finalized
        get :list
        post :check_map_title
        get :racematch
        post :racematch
        get :export_objev_sok

        get :my_approved
        get :my_change_requested
      end
      member do
        get :fusion
        get :info_table
        get :original_jpg
        get :re_register
        get :complete
        put :complete
        patch :complete
        post :copy
        post :remove
        post :authorize_proposal
        post :reject_proposal
        post :authorize_completion
        post :reject_completion
        get :update_oris_data
      end
    end

    resources :authors, only: [:index, :show, :edit, :update, :destroy] do
      member do
        post :merge
      end
    end
    resources :clubs, only: [:index, :show]

    resources :map_collections
    resources :issue_reports do
      member do
        post :resolve
      end
    end

    namespace :backend do
      resources :texts
      resources :users do
        member do
          get :become
        end
      end
      resources :oris_events
    end
  end

  get "/data/tiles/:a/:b/:c.png", to: proc { [404, {}, ['']] }

end
