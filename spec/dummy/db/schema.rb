# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160910164840) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "dorsale_addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "street_bis"
    t.string   "city"
    t.string   "zip"
    t.string   "country"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "addressable_id"
    t.string   "addressable_type"
  end

  create_table "dorsale_alexandrie_attachments", force: :cascade do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "file"
    t.integer  "sender_id"
    t.string   "sender_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dorsale_billing_machine_id_cards", force: :cascade do |t|
    t.string   "id_card_name"
    t.string   "entity_name"
    t.string   "siret"
    t.string   "legal_form"
    t.integer  "capital"
    t.string   "registration_number"
    t.string   "intracommunity_vat"
    t.string   "address1"
    t.string   "address2"
    t.string   "zip"
    t.string   "city"
    t.string   "phone"
    t.string   "contact_full_name"
    t.string   "contact_phone"
    t.string   "contact_address_1"
    t.string   "contact_address_2"
    t.string   "contact_zip"
    t.string   "contact_city"
    t.string   "iban"
    t.string   "bic_swift"
    t.string   "bank_name"
    t.string   "bank_address"
    t.string   "ape_naf"
    t.text     "custom_info_1"
    t.text     "custom_info_2"
    t.text     "custom_info_3"
    t.string   "contact_fax"
    t.string   "contact_email"
    t.string   "logo"
    t.string   "registration_city"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "dorsale_billing_machine_invoice_lines", force: :cascade do |t|
    t.integer  "invoice_id"
    t.text     "label"
    t.decimal  "quantity"
    t.string   "unit"
    t.decimal  "unit_price"
    t.decimal  "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal  "vat_rate"
    t.index ["invoice_id"], name: "index_dorsale_billing_machine_invoice_lines_on_invoice_id"
  end

  create_table "dorsale_billing_machine_invoices", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "customer_type"
    t.integer  "payment_term_id"
    t.integer  "id_card_id"
    t.date     "date"
    t.string   "label"
    t.decimal  "total_excluding_taxes"
    t.decimal  "vat_amount"
    t.decimal  "total_including_taxes"
    t.decimal  "advance"
    t.decimal  "balance"
    t.integer  "unique_index"
    t.boolean  "paid"
    t.date     "due_date"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "tracking_id"
    t.decimal  "commercial_discount"
    t.text     "comments"
    t.index ["customer_id"], name: "index_dorsale_billing_machine_invoices_on_customer_id"
    t.index ["customer_type"], name: "index_dorsale_billing_machine_invoices_on_customer_type"
    t.index ["id_card_id"], name: "index_dorsale_billing_machine_invoices_on_id_card_id"
    t.index ["payment_term_id"], name: "index_dorsale_billing_machine_invoices_on_payment_term_id"
  end

  create_table "dorsale_billing_machine_payment_terms", force: :cascade do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dorsale_billing_machine_quotation_lines", force: :cascade do |t|
    t.integer  "quotation_id"
    t.text     "label"
    t.decimal  "quantity"
    t.string   "unit"
    t.decimal  "unit_price"
    t.decimal  "total"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.decimal  "vat_rate"
    t.index ["quotation_id"], name: "index_dorsale_billing_machine_quotation_lines_on_quotation_id"
  end

  create_table "dorsale_billing_machine_quotations", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "customer_type"
    t.integer  "id_card_id"
    t.integer  "payment_term_id"
    t.date     "date"
    t.string   "label"
    t.decimal  "total_excluding_taxes"
    t.decimal  "vat_amount"
    t.decimal  "total_including_taxes"
    t.integer  "unique_index"
    t.text     "comments"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.date     "expires_at"
    t.string   "tracking_id"
    t.decimal  "commercial_discount"
    t.string   "state"
    t.index ["customer_id"], name: "index_dorsale_billing_machine_quotations_on_customer_id"
    t.index ["customer_type"], name: "index_dorsale_billing_machine_quotations_on_customer_type"
    t.index ["id_card_id"], name: "index_dorsale_billing_machine_quotations_on_id_card_id"
    t.index ["payment_term_id"], name: "index_dorsale_billing_machine_quotations_on_payment_term_id"
  end

  create_table "dorsale_comments", force: :cascade do |t|
    t.integer  "author_id"
    t.string   "user_type"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "text"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "author_type"
  end

  create_table "dorsale_customer_vault_corporations_bak", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.text     "email"
    t.string   "phone"
    t.string   "fax"
    t.text     "www"
    t.string   "legal_form"
    t.integer  "capital"
    t.string   "immatriculation_number_1"
    t.string   "immatriculation_number_2"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "european_union_vat_number"
  end

  create_table "dorsale_customer_vault_individuals_bak", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "short_name"
    t.text     "email"
    t.string   "title"
    t.string   "twitter"
    t.text     "www"
    t.text     "context"
    t.string   "phone"
    t.string   "fax"
    t.string   "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "skype"
  end

  create_table "dorsale_customer_vault_links", force: :cascade do |t|
    t.string   "title"
    t.integer  "alice_id"
    t.string   "alice_type_bak"
    t.integer  "bob_id"
    t.string   "bob_type_bak"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "dorsale_customer_vault_people", force: :cascade do |t|
    t.string   "type"
    t.integer  "old_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "corporation_name"
    t.string   "short_name"
    t.string   "avatar"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.string   "fax"
    t.string   "skype"
    t.text     "www"
    t.text     "twitter"
    t.text     "facebook"
    t.text     "linkedin"
    t.text     "viadeo"
    t.text     "data"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "dorsale_expense_gun_categories", force: :cascade do |t|
    t.string  "name"
    t.string  "code"
    t.boolean "vat_deductible"
  end

  create_table "dorsale_expense_gun_expense_lines", force: :cascade do |t|
    t.integer  "expense_id"
    t.integer  "category_id"
    t.string   "name"
    t.date     "date"
    t.float    "total_all_taxes"
    t.float    "vat"
    t.float    "company_part"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["category_id"], name: "index_dorsale_expense_gun_expense_lines_on_category_id"
    t.index ["expense_id"], name: "index_dorsale_expense_gun_expense_lines_on_expense_id"
  end

  create_table "dorsale_expense_gun_expenses", force: :cascade do |t|
    t.string   "name"
    t.string   "state"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  create_table "dorsale_flyboy_folders", force: :cascade do |t|
    t.integer  "folderable_id"
    t.string   "folderable_type"
    t.string   "name"
    t.text     "description"
    t.integer  "progress"
    t.string   "status"
    t.string   "tracking"
    t.integer  "version"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["folderable_id"], name: "index_dorsale_flyboy_folders_on_folderable_id"
    t.index ["folderable_type"], name: "index_dorsale_flyboy_folders_on_folderable_type"
  end

  create_table "dorsale_flyboy_task_comments", force: :cascade do |t|
    t.integer  "task_id"
    t.datetime "date"
    t.text     "description"
    t.integer  "progress"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.index ["task_id"], name: "index_dorsale_flyboy_task_comments_on_task_id"
  end

  create_table "dorsale_flyboy_tasks", force: :cascade do |t|
    t.integer  "taskable_id"
    t.string   "taskable_type"
    t.string   "name"
    t.text     "description"
    t.integer  "progress"
    t.boolean  "done"
    t.date     "term"
    t.date     "reminder"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "owner_type"
    t.integer  "owner_id"
    t.index ["taskable_id"], name: "index_dorsale_flyboy_tasks_on_taskable_id"
    t.index ["taskable_type"], name: "index_dorsale_flyboy_tasks_on_taskable_type"
  end

  create_table "dummy_models", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "string_field"
    t.text     "text_field"
    t.integer  "integer_field"
    t.decimal  "decimal_field"
    t.date     "date_field"
    t.datetime "datetime_field"
    t.boolean  "boolean_field"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "is_active"
    t.string   "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
