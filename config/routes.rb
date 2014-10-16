Rails.application.routes.draw do

  namespace :api, :defaults => {:format => :json} do
    get 'check_connection' , to: 'api#check_connection'
    get 'authorities', to: 'authorities#index'
    get 'authorities/:id', to: 'authorities#show'
    put 'authorities/:id', to: 'authorities#update'
    delete 'authorities/:id', to: 'authorities#purge'
    post 'authorities', to: 'authorities#create'

    get 'persons', to: 'persons#index'
    get 'persons/:id', to: 'persons#show'
    post 'persons', to: 'persons#create'
    put 'persons/:id', to: 'persons#update'
    delete 'persons/:id', to: 'persons#purge'

    get 'archives', to: 'archives#index'
    get 'archives/:id', to: 'archives#show'
    post 'archives', to: 'archives#create'
    put 'archives/:id', to: 'archives#update'
    delete 'archives/:id', to: 'archives#purge'
    put 'archives/:id/authorities/:authority_id', to: 'archives#add_authority'
    delete 'archives/:id/authorities/:authority_id', to: 'archives#remove_authority'

    get 'disks', to: 'disks#index'
    get 'disks/:id', to: 'disks#show'
    post 'disks', to: 'disks#create'
    put 'disks/:id', to: 'disks#update'
    delete 'disks/:id', to: 'disks#purge'

    get 'diskimages', to: 'disk_images#index'
    get 'diskimages/:id', to: 'disk_images#show'
    post 'diskimages', to: 'disk_images#create'
    put 'diskimages/:id', to: 'disk_images#update'

    get 'content_file_infos/:disk_image/:parent', to: 'content_file_infos#index'
  end

  


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
