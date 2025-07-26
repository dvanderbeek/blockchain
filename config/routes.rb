Blockchain::Engine.routes.draw do
  resources :transactions do
    defaults format: :json do
      collection do
        post :build
        post :status # Cleaner URL / easier to view in Postman
        get :status # More conventional REST endpoint
      end
    end
  end
end
