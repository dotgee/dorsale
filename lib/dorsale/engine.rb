require "slim-rails"
require "sass-rails"
require "bootstrap-sass"
require "bh"
require "font-awesome-sass"
require "simple_form"
require "coffee-rails"
require "jquery-rails"
require "kaminari"
require "turbolinks"
require "bootstrap-kaminari-views"
require "bootstrap-datepicker-rails"
require "cocoon"
require "select2-rails"

require "rails-i18n"
require "pundit"
require "awesome_print"
require "kaminari-i18n"
require "carrierwave"
require "aasm"
require "handles_sortable_columns"
require "csv"
require "pdf/reader"
require "prawn"
require "prawn/table"
require "combine_pdf"

if Rails.env.test? || Rails.env.development?
  require "pry"
  require "factory_girl_rails"
  require "factory_girl"
end

require "acts-as-taggable-on"
require "active_record_comma_type_cast"

module Dorsale
  class Engine < ::Rails::Engine
    isolate_namespace Dorsale

    initializer "factory_girl" do
      if Rails.env.test? || Rails.env.development?
        FactoryGirl.definition_file_paths.unshift Dorsale::Engine.root.join("spec/factories/").to_s
      end
    end

    initializer "check_rails_version" do
      if Rails.version < "5.0.0"
        warn "Dorsale 3 supports only Rails 5, please update Rails."
      end
    end

    initializer "check_pundit_policies" do
      if Rails.env.test? || Rails.env.development?
        Dorsale::PolicyChecker.check!
      end
    end

    Mime::Type.register "application/vnd.ms-excel", :xls
    Mime::Type.register "application/vnd.ms-excel", :xlsx
  end
end

require "dorsale/file_loader"
require "dorsale/polymorphic_id"
require "dorsale/simple_form"
require "dorsale/simple_form_bootstrap"
require "dorsale/model_i18n"
require "dorsale/model_to_s"
require "dorsale/alexandrie/prawn"
require "dorsale/form_back_url"
