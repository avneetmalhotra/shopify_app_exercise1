Rails.application.routes.draw do
  root 'home#index'
  resources :settings, only: :update
  get 'settings/change', to: 'settings#change'

  resources :webhooks do
    collection do
      post 'mark_new_pending_order_paid'
      post 'send_new_order_confirmation_email'
      post 'checkout'
    end
  end

  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
