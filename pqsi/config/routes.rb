Pqsi::Application.routes.draw do

  resources :csv_exports
  resources :pdf_exports

  resources :emails

  # mount ActiveGrid::Engine => "/activegrid"

  resources :time_entries

  resources :locations


  namespace :api do

      devise_scope :user do
        post 'sessions' => 'sessions#create', :as => 'login'
        delete 'sessions' => 'sessions#destroy', :as => 'logout'
      end
  end


  resources :customers do
    member do
      get :select_vendors
      post :assign_vendor
      get :summary_report
      post :summary_report
    end
  end

  resources :reports

  resources :vendors

  resources :scans

  resources :parts

  resources :clients

  resources :ncms do
    member do
      get :import_data
      get :update_hours
      post :update_hours
      put :import_data
      delete :delete_all_scans
      get :export
      get :export_pdf
      post :archive
      post :unarchive
    end

    collection do
      get :last_ncm_based_on_job
      get :archived
    end

    resources :time_entries
    resources :ncm_data_files
  end

  devise_for :users
  resources :users do
    member do
      get :add_permission
      get :remove_permission
    end
  end

  root :to => "home#index"

  match "send_reports" => "home#send_reports"

end
