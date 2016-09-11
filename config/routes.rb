Dorsale::Engine.routes.draw do
  resources :comments, only: [:create, :edit, :update, :destroy]

  resources :users, except: [:destroy]

  namespace :small_data do
    resources :filters, only: [:create]
  end



  namespace :alexandrie do
    resources :attachments, only: [:index, :create, :edit, :update, :destroy]
  end


  namespace :flyboy do
    resources :folders do
      member do
        patch :open
        patch :close
      end
    end

    resources :tasks do
      get :summary, on: :collection
      member do
        patch :complete
        patch :snooze
      end
    end

    resources :task_comments, only: [:create]
  end

  namespace :billing_machine do
    resources :id_cards, except: [:destroy, :show]
    resources :payment_terms, except: [:destroy, :show]

    resources :invoices, except: [:destroy] do
      member do
        get :copy
        patch :pay
        match :email, via: [:get, :post]
      end
    end

    resources :quotations do
      post :copy, on: :member
      get :create_invoice, on: :member
    end
  end

  namespace :customer_vault do
    namespace :people do
      get :activity
      get :list
    end

    resources :people do
      resources :links, except: [:index]
    end

    resources :corporations, path: "people", except: [:new] do
      resources :links, except: [:index]
    end

    resources :individuals,  path: "people", except: [:new] do
      resources :links, except: [:index]
    end
  end

  get "customer_vault/people/new/corporation" => "customer_vault/people#new", type: "corporation", as: :new_customer_vault_corporation
  get "customer_vault/people/new/individual"  => "customer_vault/people#new", type: "individual",  as: :new_customer_vault_individual


  namespace :expense_gun do
    resources :categories, except: [:destroy, :show]

    resources :expenses, except: [:destroy] do
      member do
        get :copy
        patch :submit
        patch :accept
        patch :refuse
        patch :cancel
      end
    end

    get "/expenses/state/:state" => "expenses#index"
    get "/expenses/state/:state/page/:page" => "expenses#index"

    get "/" => redirect{ ExpenseGun::Engine.routes.url_helpers.expenses_path }
  end
end
