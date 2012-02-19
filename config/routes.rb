Bulimia::Application.routes.draw do
  
  root :to => 'application#home_page'
  resources :physicians do
    resources :patients do
      resources :log_entries
    end
  end
  
  match "home_page" => "application#home_page", :as => "home_page"
  match "deactivate_msg/:physician_id/:patient_id" => "physicians#deactivate_message", :as => "deactivate_message"
  match "ph_deactivate" => "physicians#destroy_archive", :as => "destroy_archive"
  match "pt_archive/:physician_id/:id" => "patients#archive", :as => "archive_pt"
  match "physician/:physician_id/patient_archive" => "physicians#pt_archive_index", :as => "pt_archive_index"
  # match "admin_pt_archive/:physician_id/:id" => "patients#admin_pt_archive", :as => "admin_pt_archive"
  #   
  #   match "index_pt_archive/:physician_id" => "patients#index_pt_archive", :as => "index_pt_archive"
  
  # flash.now.alert=
  match 'phone/sms_handler' => "phone#sms_handler", :as => :sms_handler
  match "physician_log_out" => "sessions#destroy_ph", :as => "log_out"
  match "physician_log_in" => "sessions#new_physician_session", :as => "log_in"
  match "physician_find" => "sessions#create_ph_session", :as => "matched"
  match "physician_sign_up" => "physicians#new", :as => "sign_up"
  match "physician_additional_info" => "physicians#physician_additional_info", :as => "physician_additional_info"
  match "welcome_ph_instructions/:physician_id" => "physicians#welcome_ph_instructions", :as => "welcome_ph_instructions" 
  
  
  
  match "patient_log_out" => "sessions#destroy_pt", :as => "patient_log_out"
  match "patient_log_in" => "sessions#new_patient_session", :as => "patient_log_in"
  match "patient_find" => "sessions#create_pt_session", :as => "patient_matched"
  match "patient_edit/:patient_id" => "patients#patient_edit_limited", :as => "pt_edit"
  match "patient_show/:patient_id" => "patients#patient_show_limited", :as => "pt_show"
  match "patient_update/:patient_id" => "patients#patient_update_limited", :as => "pt_update"
  
  match "admin_override_pt_password_edit/:patient_id" => "patients#admin_pt_password_edit", :as => "admin_pt_pass_edit"
  match "admin_override_pt_password_update/:patient_id" => "patients#admin_pt_password_update", :as => "admin_pt_pass_update"
  match "admin" => "admin#index", :as => "admin"
  match "archived_physicians" => "admin#archived_physicians", :as => "archived_physicians"
  match "archived_patients" => "admin#archived_patients", :as => "archived_patients"
  match "active_patients" => "admin#active_patients", :as => "active_patients"
  
  
  
 
 
 
 
  # match 'phone/day' => "phone#sms_handler", :as => :day
  #   match 'phone/food' => "phone#sms_handler", :as => :food
  #   match 'phone/time' => "phone#sms_handler", :as => :time
  #   match 'phone/bvl' => "phone#sms_handler", :as => :bvl
  #   match 'phone/note' => "phone#sms_handler", :as => :note
  #   match 'phone/error' => "phone#sms_handler", :as => :error
    
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
