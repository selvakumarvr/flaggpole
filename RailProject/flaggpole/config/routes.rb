Flaggpole::Application.routes.draw do
  match "/delayed_job" => DelayedJobWeb, :anchor => false
  devise_for :users, :controllers => { :registrations => "registrations" }

  scope "portal", :as => :portal do
    devise_for :users, :class_name => 'OrganizationUser', :controllers => {
      :registrations => "portal/registrations",
      :passwords => "portal/passwords"
    }
    resources :organization_messages, :as => :messages
    root :to => 'organization_messages#index'
  end

  namespace :admin do
    resources :organizations
    resources :organization_messages, :as => "message", :path => "/admin/messages", :only => [:index, :show]
    root :to => 'dashboard#index'
  end

  resources :alerts
  resources :promotions
  resources :twitter_zips do
    member do
      get :followers_count
    end
  end

  match 'contact' => 'contact#new', :as => 'contact', :via => :get
  match 'contact' => 'contact#create', :as => 'contact', :via => :post

  namespace "api/v1", :as => :api, defaults: {format: 'json'} do
    devise_for :users, :format => false
    resources :alerts, :only => [:index, :show]
    resources :subscriptions, :only => [:index, :create, :update, :destroy]
    resources :organizations, :only => [:show] do
      get 'archive', on: :collection
    end
    resources :zipcodes, :only => [] do
      get 'archive', on: :collection
    end
    resources :devices, :only => [:index, :create, :update, :destroy]
    match 'timeline' => 'timeline#index', :as => 'timeline', :via => :get
  end

  root :to => 'pages#home'
  match '/:controller(/:action(/:id))'
end
