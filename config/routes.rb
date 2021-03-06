SampleApp::Application.routes.draw do

  
  
  root 'pages#home'
  resources :sessions, :only => [:new, :create, :destroy]
  resources :microposts, :only => [:create, :destroy]
  resources :relationships, :only => [:create, :destroy]

  match '/signup', :to => 'users#new', via: :all
  match '/contact', :to => 'pages#contact', via: :all # via e metodot so koj se get ili post
  match '/about', :to => 'pages#about', via: :all
  match '/help', :to => 'pages#help', via: :all

  resources :users do # adds routes for /users/1/following i /users/1/followers
    member do         # dava named route following_user_path(1) i followers_user_path(brojka)
      get :following, :followers
    end
  end



  match '/signin', :to => 'sessions#new', via: :all
  match '/signout', :to => 'sessions#destroy', via: :all
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # 
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
end
