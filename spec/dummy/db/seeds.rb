# encoding: utf-8

puts "Stating data seed"

require "database_cleaner"

DatabaseCleaner.clean_with(:truncation, {except: %w(
  ar_internal_metadata
  schema_migrations
  spatial_ref_sys
)})

user = User.create!(email: "demo@agilidee.com", password: "password")

id_card = Dorsale::BillingMachine::IdCard.create!(id_card_name: "Bidule Corp", entity_name: "Bidule Corp")
payment_term = Dorsale::BillingMachine::PaymentTerm.create!(label: "A réception")

corporation1 = Dorsale::CustomerVault::Corporation.create!(
  :name               => "agilidée",
  :email              => "contact@agilidee.com",
  :www                => "http://www.agilidee.com/",
  :phone              => "04 91 xx xx xx",
  :fax                => "04 91 xx xx xx",
  :tag_list           => %w(client),
  :address_attributes => {
    :city    => "Marseille",
    :country => "France",
  }
)

Dorsale::BillingMachine::Invoice.create!(
  :label        => 'Commande de bombons',
  :id_card      => id_card,
  :customer     => corporation1,
  :payment_term => payment_term,
  :lines_attributes => [
    {
      :label      => "Bombons en sucre",
      :quantity   => 3.2,
      :unit_price => 14,
   }
  ]
)

corporation2 = Dorsale::CustomerVault::Corporation.create!(
  :name     => "Truc Bidule SARL",
  :email    => "truc@bidule.com",
  :phone    => "04 91 xx xx xx",
  :tag_list => %w(prospect certain),
  :address_attributes => {
    :city    => "Marseille",
    :country => "France",
  }
)

corporation2.comments.create!(
  :text => "Je viens d'avoir cette boite au téléphone, il faut leur faire un devis.",
  author: user
)

Dorsale::BillingMachine::Quotation.create!(
  :label            => 'Application sur mesure',
  :id_card          => id_card,
  :customer         => corporation2,
  :payment_term     => payment_term,
  :lines_attributes => [
    {
        :label      => "Développement",
        :quantity   => 14,
        :unit_price => 750,
    },
    {
        :label      => "Gestion de projet",
        :quantity   => 5,
        :unit_price => 1200,
    }
  ]
)

individual1 = Dorsale::CustomerVault::Individual.create!(
  :first_name => "Henri",
  :last_name  => "MARTIN",
  :email      => "henri.martin@example.com",
  :phone      => "04 91 xx xx xx",
  :tag_list   => %w(prospect potentiel),
  :address_attributes => {
    :city    => "Marseille",
    :country => "France",
  }
)

individual2 = Dorsale::CustomerVault::Individual.create!(
  :first_name => "Jean",
  :last_name  => "DUPONT",
  :email      => "jean.dupon@example.com",
  :phone      => "04 91 xx xx xx",
  :tag_list   => %w(développeur rails freelance),
  :address_attributes => {
    :city    => "Marseille",
    :country => "France",
  }
)

individual2.comments.create!(
  :text   => "Développeur, premier contact pour mutualiser un projet.",
  :author => user,
)

folder1 = Dorsale::Flyboy::Folder.create!(
  :name        => "Dorsale v2",
  :description => "Tâches pour la version 2 de Dorsale"
)

folder1_task1 = folder1.tasks.create!(
  :name        => "Traduction",
  :description => "Traduire en français et en anglais"
)

folder1_task1.comments.create!(
  :description => "Traduction française terminée",
  :progress    => 50,
  :author      => user,
)

folder1_task2 = folder1.tasks.create!(
  :name        => "Rediger les documentations",
  :description => "Dorsale, CustomerVault, Flyboy, ..."
)

corporation2_task1 = Dorsale::Flyboy::Task.create!(
  :taskable    => corporation2,
  :name        => "Relancer et se faire payer"
)

corporation2_task1.comments.create!(
  :description => "Relance faire aujourd'hui. Paiement d'ici la fin de la semaine.",
  :progress    => 50,
  :author      => user,
)

Dorsale::ExpenseGun::Category.create!(name: "Telecom", vat_deductible: true)
Dorsale::ExpenseGun::Category.create!(name: "Transport", vat_deductible: false)
