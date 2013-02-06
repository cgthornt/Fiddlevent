Fiddlevent::Application.routes.draw do
  resources :events, :users, :locations, :events,:filter_sets
  
  resources :merchants do
    collection do
      get :profile
    end
  end
  
  resources :filters do
    collection do
      get :index
      post :rebuild
    end
  end
  
  resources :admin do
    collection do
      get :users
    end
  end
  


  # type "rake routes" for the available routes
  devise_for :user,
    :controllers => { :registrations => "registrations" }
    
  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    delete "logout", :to => "devise/sessions#destroy"
  end
  
  resources :pages do
    collection do
      get "register"
    end
  end
  
  resources :search do
    collection do
      get :index, :cart_ajax, :event_ajax_full
      post :index
    end
  end

  
  # Allow all actions in the welcome and search controller
  match 'welcome/(:action(.:format))' => 'welcome'

  
  root :to => 'welcome#index'
end
