Rails.application.routes.draw do

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'
  
  Spree::Core::Engine.add_routes do
    resources :greetingcards
  end
  
  Spree::Core::Engine.add_routes do
    namespace :admin do
      
      get '/search/greetingcards', to: "search#greetingcards", as: :search_greetingcards
      
      resources :greetingcards do
        resources :greetingcard_properties do
          collection do
            post :update_positions
          end
        end
        resources :images do
          collection do
            post :update_positions
          end
        end
        member do
          post :clone
          get :stock
        end
        resources :variants do
          collection do
            post :update_positions
          end
        end
        resources :variants_including_master, only: [:update]
      end
    end
  end
  
  Spree::Core::Engine.add_routes do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
    
      resources :greetingcards do
        resources :images
        resources :variants
        resources :greetingcard_properties
      end

      get '/taxons/greetingcards', to: 'taxons#greetingcards', as: :taxon_greetingcards
    end

  end
end
  
  #Spree::Core::Engine.draw_routes
  
  
          # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
