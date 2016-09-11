class CreateDorsaleCustomerVaultPeople < ActiveRecord::Migration[5.0]
  class Person < ActiveRecord::Base
    extend Forwardable
    self.table_name = "dorsale_customer_vault_people"
  end

  class Individual < Person
    serialize      :data,  Dorsale::CustomerVault::IndividualData
    def_delegators :data, *Dorsale::CustomerVault::IndividualData.methods_to_delegate
  end

  class Corporation < Person
    serialize      :data,  Dorsale::CustomerVault::CorporationData
    def_delegators :data, *Dorsale::CustomerVault::CorporationData.methods_to_delegate
  end

  class OldIndividual < Person
    self.table_name = "dorsale_customer_vault_individuals_bak"
  end

  class OldCorporation < Person
    self.table_name = "dorsale_customer_vault_corporations_bak"
  end

  def up
    create_table :dorsale_customer_vault_people do |t|
      t.string :type
      t.integer :old_id
      t.string :first_name
      t.string :last_name
      t.string :corporation_name
      t.string :short_name
      t.string :avatar
      t.string :email
      t.string :phone
      t.string :mobile
      t.string :fax
      t.string :skype
      t.text :www
      t.text :twitter
      t.text :facebook
      t.text :linkedin
      t.text :viadeo
      t.text :data
      t.timestamps null: false
    end

    rename_table :dorsale_customer_vault_individuals,  :dorsale_customer_vault_individuals_bak
    rename_table :dorsale_customer_vault_corporations, :dorsale_customer_vault_corporations_bak

    OldCorporation.all.each do |old_corporation|
      corporation = Corporation.create!(
        :old_id                    => old_corporation.id,
        :corporation_name          => old_corporation.name,
        :short_name                => old_corporation.short_name,
        :email                     => old_corporation.email,
        :phone                     => old_corporation.phone,
        :fax                       => old_corporation.fax,
        :www                       => old_corporation.www,
        :legal_form                => old_corporation.legal_form,
        :capital                   => old_corporation.capital,
        :immatriculation_number_1  => old_corporation.immatriculation_number_1,
        :immatriculation_number_2  => old_corporation.immatriculation_number_2,
        :created_at                => old_corporation.created_at,
        :updated_at                => old_corporation.updated_at,
        :european_union_vat_number => old_corporation.european_union_vat_number
      )

      update_models!("Dorsale::CustomerVault::Corporation", corporation.old_id, corporation.id)
    end

    OldIndividual.all.each do |old_individual|
      individual = Individual.create!(
        :old_id     => old_individual.id,
        :first_name => old_individual.first_name,
        :last_name  => old_individual.last_name,
        :short_name => old_individual.short_name,
        :email      => old_individual.email,
        :title      => old_individual.title,
        :twitter    => old_individual.twitter,
        :www        => old_individual.www,
        :context    => old_individual.context,
        :phone      => old_individual.phone,
        :fax        => old_individual.fax,
        :mobile     => old_individual.mobile,
        :created_at => old_individual.created_at,
        :updated_at => old_individual.updated_at,
        :skype      => old_individual.skype,
      )

      update_models!("Dorsale::CustomerVault::Individual", individual.old_id, individual.id)
    end

    Individual.update_all(type: "Dorsale::CustomerVault::Individual")
    Corporation.update_all(type: "Dorsale::CustomerVault::Corporation")

    rename_column :dorsale_customer_vault_links, :alice_type, :alice_type_bak
    rename_column :dorsale_customer_vault_links, :bob_type,   :bob_type_bak
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def update_models!(type, old_id, new_id)
    update_model! Dorsale::CustomerVault::Link,       :alice,       type, old_id, new_id
    update_model! Dorsale::CustomerVault::Link,       :bob,         type, old_id, new_id
    update_model! Dorsale::Flyboy::Folder,            :folderable,  type, old_id, new_id
    update_model! Dorsale::Flyboy::Task,              :taskable,    type, old_id, new_id
    update_model! Dorsale::BillingMachine::Invoice,   :customer,    type, old_id, new_id
    update_model! Dorsale::BillingMachine::Quotation, :customer,    type, old_id, new_id
    update_model! Dorsale::Address,                   :addressable, type, old_id, new_id
    update_model! Dorsale::Comment,                   :commentable, type, old_id, new_id
    update_model! ActsAsTaggableOn::Tagging,          :taggable,    type, old_id, new_id
  end

  def update_model!(model, field, type, old_id, new_id)
    type_field = "#{field}_type"
    id_field   = "#{field}_id"

    model
      .where(type_field => type, id_field => old_id)
      .update_all(type_field => "Dorsale::CustomerVault::Person", id_field => new_id)
  end
end
