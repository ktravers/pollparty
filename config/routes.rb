Rails.application.routes.draw do

  root 'welcome#index'
  get 'search' => 'search#show'

end
