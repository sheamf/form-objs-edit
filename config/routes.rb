FormObjsEdit::Application.routes.draw do

  root 'companies#index'

  resources :companies

end


