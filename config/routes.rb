require 'api_constraints'

Rails.application.routes.draw do

  namespace :api, path: '/', constraints: { subdomain: 'api' } do  
    scope module: :v1, constraints: ApiConstraints.new('v1') do
      mount_devise_token_auth_for 'User', at: 'auth'
      with_options except: [:new, :edit], shallow: true do |without_views|
        without_views.resources :projects do
          without_views.resources :tasks do
            # just adding a new value to the same option will cause the clobbing: 
            # the second value will override the first one when calling Hash#merge;
            # the only way is setting the old value in a pair with the new one
            without_views.with_options except: [:new, :edit, :update] do |without_update|
              without_update.resources :comments do
                without_update.resources :attachments
              end
            end
          end
        end  
      end
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
