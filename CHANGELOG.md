# Changelog

## Next realease

- Migrate from CanCan to Pundit
- ExpenseGun improvements
  - UX
  - Nested form
  - Copy expense
- Replace Selectize by Select2
- Changes js/css file names :
  - dorsale/dependencies
  - dorsale/common
  - dorsale/engines
- CustomerVault
  - Corporation and Individual merged into STI model
  - Add avatar and other new fields
  - Add Corporations and Individuals lists
- Refactoring
- UX improvements
- Use ajax to CRUD comments

## 3.0.3

- Refactor controllers
- Refactor back url
- Update config cucumber
- Rename abilities (index => list, show => read)
- Change some redirects after create/update

## 3.0.2

- Add new controllers :
  - Expense Categories
  - Payment Terms
  - Id Cards
- Fix Expenses VAT min amount

## 3.0.1

- Fix ExpenseGun min amounts

## 3.0.0

- Migrate to Rails 5
- Drop Rails 4 support
- Delete 2.8.x versions

## 2.7.3

- Fix Fix ActiveRecordCommaTypeCast to accept NBSP

## 2.7.2

- Small refactor on ExpenseGun

## 2.7.1

- Modals improvements

## 2.7.0

- Add ajax to attachments + progress bar
- Small CSS fixes

## 2.6.8

- Small changes to bootstrap_nav_left.sass

## 2.6.7

- Update Ruby development version to 2.2.5
- Update Rails developement version
- Remove Gemfile.lock from Git
- Add zip-zip gem for compabibility

## 2.6.6

- Fix negative amount on BillingMachine

## 2.6.5

- Add XLSX serializer
- Datepicker : add today button + autoclose

## 2.6.4

- Add datepicker setup after cocoon insert

## 2.6.3

- Add generic filters

## 2.6.2

- Invoices small changes and refactor

## 2.6.1

- Add modals css/js

## 2.6.0

- Add currencies support in BillingMachine (default is €)

## 2.5.0

- Changes/refactor on invoice/quotation PDFs - it can break extended PDFs

## 2.4.3

- Fix i18n

## 2.4.2

- Minor fix in invoice PDF

## 2.4.1

- ExpenseGun small fixes

## 2.4.0

- Change filters - break compatibility but easy to fix
- Add documents on expenses

## 2.3.5

- Add "In two weeks" on tasks summary
- Add Model::ts to i18n plural model name

## 2.3.4

- Use `polymorphic_path` instead of `url_for`

## 2.3.3

- Helpers small changes

## 2.3.2

- Small changes on users list

## 2.3.1

- Fix path on expense status

## 2.3.0

- Add ExpenseGun

## 2.2.16

- Fix tasks cron

## 2.2.14

- Improve number helpers
- Add Emails for tasks creation

## 2.2.13

- CustomerVault : Fix contact count

## 2.2.12

- CustomerVault : Move create actions to top
- CustomerVault : Remove breadcrumbs
- BillingMachine : Add invoices comments
- BillingMachine : Empty 0 value inputs on focus
- Small fixes

## 2.2.11

- Add avatar support

## 2.2.10

- Fix filters
- Add CustomerVault infos in context
- Move BillingMachine context to top
- Improve `info` helper

## 2.2.9

- Invoices small changes and fixes

## 2.2.8

- Rebuild gem

## 2.2.7

- Send invoices by email
- Add colors to quotations
- Add filter by status to quotations
- Small fixes

## 2.2.6

- Quotation to invoice : edit before save

## 2.2.5

- Fix invoices colors
- Fix invoices totals
- Fix partials names

## 2.2.4

- Attachments : Do not validate presence of sender to allow all attachments without sender to be updated

## 2.2.3

- Add attachments renaming
- Fix invoices errors

## 2.2.2

- Add default value to filters
- Add ability do task comment view

## 2.2.1

- Small fixes on invoices and quotations

## 2.2.0

- Add per line vat rate mode
- Change billing machine column names
- New invoices and quotations views

## 2.1.15

- Hide delete attachment button is not allowed by ability

## 2.1.14

- Add sender to attachments

## 2.1.13

- Add owner to tasks context

## 2.1.12

- Fix comments on destroyed individuals

## 2.1.11

- Add users management
- Change invoices and quotations authorizes

## 2.1.10

- Fix destroy dependencies

## 2.1.9

- Add new template for invoices and quotations

## 2.1.8

- Quotation copy
- Convert quotation to invoice
- Add quotation states
- Add "download" attributes to `download_button` helper

## 2.1.7

- Fix i18n
- Add skype to CustomerVault

## 2.1.6

- Add commercial discount to invoices and quotations

## 2.1.5

- Fix Flyboy error on failing create task

## 2.1.4

- EN i18n fix

## 2.1.3

- Add tasks summary
- Add EN translations

## 2.1.2

- Move People.list to UserScope

## 2.1.1

- Split Flyboy AbilityHelper

## 2.1.0

- Begin migration to UserScope.

## 2.0.2

- Embedded user concept into dorsale: the hosting app now shall provide a current_user with specific methods. Check requirements in README.

## 2.0.1

- Added periods management as decimal separator

## 2.0.0

- Import CustomerVault
- Import BillingMachine
- Import Flyboy
- Create Alexandrie
- More translations
- More helpers and partials
- I18n refactoring
- Filters cookie expiry

## 1.2.6

- Add `engine_polymorphic_path()` helper
- Add number helpers
- Add i18n attributes

## 1.2.5

- Fix JS back_url

## 1.2.4

- JS to add "back_url" to forms

## 1.2.3

- Add helpers : email_link, web_link, tel_link, twitter_link
- Add i18n actions sort and sort_by
- Fix i18n address key

## 1.2.2

- Add bootstrap-datepicker

## 1.2.1

- Ready for ruby 2.2.2
- Pagination style + helper + i18n
- Move filters button in separate helper

## 1.2.0

- Filters
  - Merge instead of replace
  - Import spec
  - Add classes to helper buttons
- I18n
  - Add actions
  - Add attributes
- form_button
  - Add icons
  - Add i18n
- Rewrite context_info helper and add "br" support
- Address
  - Add inverse_of
  - City is now optional
  - Remove controllers and views
- Comments
  - i18n dates
  - Split view

## 1.1.4

- Add filters buttons helper
- Add link_helper
- Add all_helpers
- Add flash partial
- Add common i18n actions, labels, ...

## 1.1.3

- Add button_helper

## 1.1.2

- Fix sprockets/font-awesome error

## 1.1.1

- Fix icon helper (font-awesome icon helper should override bh icon helper)

## 1.1.0

- Import agilidee_commons :
  - Contexts
  - Form helpers
  - simple_form config
  - Text helpers
  - polymorphic_id
- Add small_data (namespaced Dorsale::SmallData)
- Add and require common gem dependencies
- Add commons CSS (tables, forms)

## 1.0.4

- Change redirect after comment

## 1.0.3

- Add Comments

## 1.0.2

- Add Dorsale::Search
