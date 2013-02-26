Rainbow::Application.routes.draw do

  root :to => 'home#index'
  
  resources :stylesheets, only: [] do
    collection do
      get 'layout'
      get 'grid'
      get 'button'
    end
  end

end
