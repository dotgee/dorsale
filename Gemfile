source "https://rubygems.org"

ruby_version_file = File.join(__dir__, ".ruby-version")
if File.exists?(ruby_version_file)
  ruby File.read(ruby_version_file).strip
else
  puts ".ruby-version file not found"
end

gem "rails", "5.0.0"
gem 'devise'
gem 'devise-bootstrap-views'
gem 'devise-i18n'
gem 'pg'
gem 'uglifier'
gem "pry-rails"
gem "awesome_print"
gem "delayed_job_active_record"

gemspec

group :development, :test do
  gem "byebug"
  gem "faker"
  gem "database_cleaner"
  gem "desktop_delivery"
end

group :test do
  gem "minitest"
  gem "thor"
  gem "sqlite3"
  gem "rspec-rails"
  gem "rspec-wait"
  gem "shoulda-matchers", "2.5.0"
  gem "rails-controller-testing"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "poltergeist"
  gem "factory_girl_rails"
  gem "guard"
  gem "guard-cucumber"
  gem "guard-rspec"
  gem "guard-rubocop"
  gem "timecop"
  gem "pdf-inspector"
  gem "yomu"
end
