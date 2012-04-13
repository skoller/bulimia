Bulimia::Application.routes.draw do
  
  root :to => 'application#home_page'
  resources :physicians do
    resources :patients do
      resources :log_entries
    end
  end
  
  match "home_page" => "application#home_page", :as => "home_page"
  match "deactivate_pt_msg/:physician_id/:patient_id" => "physicians#deactivate_pt_message", :as => "deactivate_pt_message"
  match "deactivate_ph_msg/:physician_id" => "physicians#deactivate_ph_message", :as => "deactivate_ph_message"
  match "ph_deactivate" => "physicians#destroy_archive", :as => "destroy_archive"
  match "pt_archive/:physician_id/:id" => "patients#archive", :as => "archive_pt"
  match "physician/:physician_id/patient_archive" => "physicians#pt_archive_index", :as => "pt_archive_index"
  match "code" => "sessions#new_patient_code_verification", :as => "patient_code"
  match "new_patient" => "sessions#new_patient_start_code_entry", :as => "new_patient_start_code_entry"
  match "new_patient_password_setup/:pt_id" => "sessions#new_patient_password_setup", :as => "new_patient_password_setup"
  match "p_set/:pt_id" => "sessions#password_set", :as => "password_set"
  
  
  
  # flash.now.alert=
  match 'phone/sms_handler' => "phone#sms_handler", :as => "sms_handler"
  match 'after_start_code_web_handler' => "patients#after_start_code_web_handler", :as => "after_start_code_web_handler"
  
  match "physician_log_out" => "sessions#destroy_ph", :as => "log_out"
  match "physician_log_in" => "sessions#new_physician_session", :as => "log_in"
  match "physician_find" => "sessions#create_ph_session", :as => "matched"
  match "physician_sign_up" => "physicians#new", :as => "sign_up"
  match "physician_additional_info" => "physicians#physician_additional_info", :as => "physician_additional_info"
  match "welcome_ph_instructions/:physician_id" => "physicians#welcome_ph_instructions", :as => "welcome_ph_instructions" 
  match "unarch_pt/:id/:patient_id" => "physicians#unarchive_patient", :as => "unarchive_patient"
  match "physician_account/:physician_id" => "physicians#physician_account", :as => "physician_account"
  match "edit_physician_account/:physician_id" => "physicians#edit_physician_account", :as => "edit_physician_account"
  match "physician_pswd_edit/:physician_id" => "physicians#ph_password_edit", :as => 'ph_password_edit'
  match "physician_pswd_update/:physician_id" => "physicians#ph_password_update", :as => 'ph_password_update'
  
  
  match "patient_log_out" => "sessions#destroy_pt", :as => "patient_log_out"
  match "patient_log_in" => "sessions#new_patient_session", :as => "patient_log_in"
  match "patient_find" => "sessions#create_pt_session", :as => "patient_matched"
  match "patient_edit/:patient_id" => "patients#patient_edit_limited", :as => "pt_edit"
  match "patient_show/:patient_id" => "patients#patient_show_limited", :as => "pt_show"
  match "patient_update/:patient_id" => "patients#patient_update_limited", :as => "pt_update"
  match "patient_welcome/:patient_id" => "patients#patient_welcome", :as => "patient_welcome"
  
  
  match "admin_override_pt_password_edit/:patient_id" => "patients#admin_pt_password_edit", :as => "admin_pt_pass_edit"
  match "admin_override_pt_password_update/:patient_id" => "patients#admin_pt_password_update", :as => "admin_pt_pass_update"
  match "admin" => "admin#index", :as => "admin"
  match "archived_physicians" => "admin#archived_physicians", :as => "archived_physicians"
  match "archived_patients" => "admin#archived_patients", :as => "archived_patients"
  match "active_patients" => "admin#active_patients", :as => "active_patients"
  match "deact_and_arch_pt/:patient_id" => "admin#deactivate_and_archive_patient", :as => "deactivate_and_archive_patient"
  match "react_and_unarch_pt/:patient_id" => "admin#reactivate_and_unarchive_patient", :as => "reactivate_and_unarchive_patient"
  match "archive_a_physician/:physician_id" => "admin#archive_a_physician", :as => "archive_a_physician"
  match "unarchive_a_physician/:physician_id" => "admin#unarchive_a_physician", :as => "unarchive_a_physician"
  

    
  
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
