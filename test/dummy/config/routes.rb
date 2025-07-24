Rails.application.routes.draw do
  mount Blockchain::Engine => "/blockchain"
end
