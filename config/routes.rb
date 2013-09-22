Yava::Application.routes.draw do

	root 'home#index'
	
	match "/search", to: "home#search", via: "get"
	match "/search", to: "home#search", via: "post"
	match "/msearch", to: "home#msearch", via: "get"
	match "/msearch", to: "home#msearch", via: "post"
	match "/about", to: "home#about", via: "get"
	match "/index", to: "home#index", via: "get"
#	match "/contact", to: "home#contact", via: "get"
	match "/sitemap", to: "home#sitemap", via: "get"
	match "/tos", to: "home#tos", via: "get"
	match "/pp", to: "home#pp", via: "get"
	match "/stat", to: "home#stat", via: "get"

	match "/signin", to: "users#signin", via: "get"
#	match "/signin", to: "users#new", via: "get"
	match "/auth/:provider/callback", :to => "sessions#create", via: "get"
	match "/auth/failure", :to => "sessions#failure", via: "get"
	match "/signout", :to => "sessions#destroy", via: "get"
	match "/users/:id/email", to: "users#email", via: "get"

	resources :ingredients
	resources :ingredient_synonyms
	resources :products
	resources :users
	resources :manufacturers
	resources :brands
	resources :cities
	resources :labels
	resources :features
	resources :nutvals

	resources :inquiries
	match "/inquiries/new", to: "inquiries#create2", via: "post"
	resources :comments

#	resources :j_product_inquiries
#	resources :j_product_comments
	resources :j_product_features
	resources :j_product_labels
	resources :j_ingredient_classnames
	
	resources :classnames
	resources :packagematerials
	resources :categories
	resources :subcategories
	resources :veganities


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  #root 'products#index'

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
