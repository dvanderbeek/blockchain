Blockchain::Engine.routes.draw do
  resources :transactions do
    post :build, on: :collection
    member do
      get :status
    end
  end
end
