@javascript
Feature: Invoice Management
  As a user
  I want to create invoices
  In order to get paid!

  Background:
    Given an existing id card

  Scenario: Existing invoice displayed in invoices page
    And an existing customer
    And an existing invoice
    When the user goes to the invoices page
    And the invoice line shows the right date
    And the invoice line shows the right traking-id
    And the invoice line shows the right customer's name
    And the invoice line shows the right total-duty value
    And the invoice line shows the right all taxes value

  Scenario: Paginate by 50 invoices
    Given 75 existing invoices
    When the user goes to the invoices page
    Then he should see 50 invoices
    When he goes to the next page
    Then he should see 25 invoices

  Scenario: Copy invoice
    And an existing invoice
    When the user goes to the invoice details
    And wants to copy it
    Then a new invoice is displayed with the informations

  Scenario: Empty invoice
    And an existing emtpy invoice
    When the user goes to the invoices page
    Then the invoice is displayed correctly

  Scenario: Invoice details
    And an existing invoice
    When the user goes to the invoice details
    Then he can see all the informations

  Scenario: New invoice for existing customer
    And an existing customer
    And an existing payment term
    When the user goes to the invoices page
    And he creates a new invoice
    And he fills the reference, the date and the payment terms
    And he chooses the customer
    And he fills a line with "Bidule", "4", "€", "10"
    Then the new line's total should be "40,00€"
    And the total duty is "40,00€"
    When he adds a new line
    And he fills a line with "Machin truc", "8", "€", "20"
    Then the new line's total should be "160,00€"
    Then the total duty is "200,00€"
    And the VAT due is "40,00€"
    And the total all taxes included is "240,00€"
    When he saves the invoice
    Then a message signals the success of the creation
    Then it's added to the invoice list

  Scenario: Edit invoice
    And an existing invoice
    When the user goes to the invoice details
    And he goes on the edit page of the invoice
    And changes the label
    When he saves the invoice
    Then a message signals the success of the update
    Then the invoices's label has changed

  Scenario: New invoice with advance
    When the user goes to the invoices page
    And he creates a new invoice
    And he fills a line with "Bidule", "1", "€", "100"
    Then the total all taxes included is "120,00€"
    And the advance is "0"€
    And the balance included is "120,00€"
    When he changes the advance to "30"€
    Then the balance included is "90,00€"
    When he saves the invoice
    Then a message signals the success of the creation
    When he goes to the newly created invoice page
    Then the advance is "30.0"€
    Then the balance included is "90,00€"

  Scenario: New invoice with default date
    When the user goes to the invoices page
    And he creates a new invoice
    Then the invoice default date is set to today's date.
    Then the invoice default due date is set to today's date.

  Scenario: New invoice with default VAT rate
    When the user goes to the invoices page
    And he creates a new invoice
    Then the VAT rate is "20"

  Scenario: Existing invoice with non default VAT rate
    And an existing invoice with a "19.6"% VAT rate
    And he goes on the edit page of the invoice
    # value should be preserved
    Then the VAT rate is "19.6"

  Scenario: New invoice with non default VAT rate
    When the user goes to the invoices page
    And he creates a new invoice
    And he fills a line with "Bidule", "1", "€", "100"
    And he changes the VAT rate to "19.6"
    Then the VAT rate is "19.6"
    And the VAT due is "19,60€"
    And the total all taxes included is "119,60€"

  Scenario: Change values without saving(test live preview)
    When the user goes to the invoices page
    And he creates a new invoice
    And he fills a line with "Bidule", "2", "€", "50"
    Then the new line total is "100,00€"
    And he fills a line with "Bidule", "10", "€", "100"
    Then the existing line total is "1.000,00€"
    And the VAT due is "200,00€"
    And the total all taxes included is "1.200,00€"
    And he changes the VAT rate to "19.6"
    And the VAT due is "196,00€"
    And the total all taxes included is "1.196,00€"

  Scenario: Export invoices in CSV
    And an existing invoice
    When the user goes to the invoices page
    Then he finds and clicks on the download CSV export file

  Scenario: Existing unpaid invoice set to paid
    And an existing invoice
    When the user goes to the invoice details
    Then the invoice is marked unpaid
    And he set the invoice as paid
    Then the invoice is marked paid
    And a message signals that the invoice is set to paid
    And the invoice status is set to paid
    And can't set the invoice as paid again

  Scenario: Existing paid invoice set to unpaid
    And an existing paid invoice
    When the user goes to the invoices page
    Then the invoice is marked paid
    And can't set the invoice as paid again
    And he goes on the edit page of the invoice
    When he marks the invoice as unpaid
    And he saves the invoice
    Then a message signals the success of the update
    And the invoice status is set to unpaid

  Scenario: Filter by customer
    Given a bunch of existing invoices
    When the user goes to the invoices page
    When he filters by one customer
    Then only the invoices of this customer do appear

  Scenario: Filter by date
    Given a bunch of existing invoices
    When the user goes to the invoices page
    When he filters by date on today
    Then only the invoices of today do appear

  Scenario: Filter by status
    Given a bunch of existing invoices
    When the user goes to the invoices page
    When he filters by status on paid
    Then only the invoices paid do appear

  Scenario: Existing invoice displayed in invoices page
    Given an existing invoice
    When the user goes to the invoices page
    Then the invoice line shows the right date

  Scenario: Paid invoice green in list
    Given an existing paid invoice
    When the user goes to the invoices page
    Then the invoice status should be "paid"

  Scenario: Unpaid invoice with due date not passed have no color in list
    Given an existing unpaid invoice
    And its due date is not yet passed
    When the user goes to the invoices page
    Then the invoice paid status should not have a color

  Scenario: Unpaid invoice with due date the same day have no color in list
    Given an existing unpaid invoice
    And its due date is the same day
    When the user goes to the invoices page
    Then the invoice paid status should not have a color

  Scenario: Unpaid invoice with due date just passed appears orange in list
    Given an existing unpaid invoice
    And its due date is yesterday
    When the user goes to the invoices page
    Then the invoice status should be "late"

  Scenario: Unpaid invoice with due date passed by 15 days appears orange in list
    Given an existing unpaid invoice
    And its due date is 14 days ago
    When the user goes to the invoices page
    Then the invoice status should be "late"

  Scenario: Unpaid invoice with due date passed by 16 days appears red in list
    Given an existing unpaid invoice
    And its due date is 15 days ago
    When the user goes to the invoices page
    Then the invoice status should be "on_alert"

  Scenario: Invoice Pdf with valid name
    Given an existing customer
    Given an existing invoice
    When the user download the pdf
    Then the PDF should have the filename "Facture_2014-01_SN.pdf"
