Rails.application.routes.draw do
  root :to => 'bookparty#login'
  match ":controller(/:action(/:id))", :via => [:post, :get]
end
