Rails.application.routes.draw do
  
  resources :email_subscribers
  
  get "/aff/:id" => "affiliates#capture"
  get "/ref/:key" => "affiliates#referral"
  get "/fbref/:key" => "affiliates#facebook_referral"
  get "eb" => "email_blasts#redirect"
  get "pixel" => "email_blasts#pixel"
  get "ocr/:uuid" => "email_subscribers#one_click_remove"
  post "ocr/:uuid" => "email_subscribers#resubscribe"
  
  namespace :account do
    resources :email_subscriptions
  end
  
  namespace :admin do   
    namespace :marketing do
      resources :email_lists
      resources :email_subscribers
      resources :email_blasts
      resources :affiliate_campaigns
    end 
  end
  
end
