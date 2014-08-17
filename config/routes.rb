Rails.application.routes.draw do
  
  namespace :admin do 
    
    namespace :marketing do
      resources :email_lists
      resources :email_subscribers
      resources :email_blasts
      resources :affiliate_campaigns
    end
    
  end
  
end
