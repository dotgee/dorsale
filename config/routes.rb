Dorsale::Engine.routes.draw do
  # Comments

  resources :comments, only: [:index, :create, :edit, :update, :destroy]

  # Users

  resources :users, except: [:destroy]

  # Small Sata / Filters

  namespace :small_data do
    resources :filters, only: [:create]
  end

  # Alexandrie / Attachments

  namespace :alexandrie do
    resources :attachments, only: [:index, :create, :edit, :update, :destroy]
  end

  # Flyboy

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

  # Billing Machine

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

  # Customer Vault

  get "customer_vault/corporations" => "customer_vault/people#corporations"
  get "customer_vault/individuals"  => "customer_vault/people#individuals"

  namespace :customer_vault do
    namespace :people do
      get :activity
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

    resources :corporations, only: [:new, :create], controller: :people
    resources :individuals,  only: [:new, :create], controller: :people
  end

  # Expense Gun

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

    get "/" => redirect{ ExpenseGun::Engine.routes.url_helpers.expenses_path }
  end

end
