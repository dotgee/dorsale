@javascript
Feature: Invoice Management
  As a user
  I want to create invoices and quotations with multiple vat
  In order to get paid!

  Background:
    Given an authenticated user
    Given an existing id card
    Given billing machine in multiple vat mode
    And an existing customer
    And an existing payment term

 Scenario: New invoice for existing customer
    When the user goes to the invoices page
    And he creates a new invoice
    And he fills the reference, the date and the payment terms
    And he chooses the customer
    And he fills a multiple vat line with "Bidule", "4", "€", "20", "10"
    Then the new line total is "40,00"
    And the total excluding taxes is "40,00"
    When he adds a new line
    And he fills a multiple vat line with "Machin truc", "8", "€", "10", "20"
    Then the new line total is "160,00"
    And he fill the commercial discount with "20,00"
    Then the total excluding taxes is "180,00"
    And the VAT due is "21,60"
    And the total including taxes is "201,60"
    When he saves the invoice
    Then a message signals the success of the creation
    Then it's added to the invoice list

 Scenario: New quotation for existing customer
    And an existing customer
    And an existing payment term
    When the user goes to the quotations page
    And he creates a new quotation
    And he fills the reference and the date
    And he fill the quotation expiry
    And he chooses the customer
    And he fills a multiple vat line with "Bidule", "4", "€", "20", "10"
    Then the new line total is "40,00"
    And the total excluding taxes is "40,00"
    When he adds a new line
    And he fills a multiple vat line with "Machin truc", "8", "€", "10", "20"
    Then the new line total is "160,00"
    And he fill the quotation commercial discount with "20,00"
    And the total excluding taxes is "180,00"
    And the VAT due is "21,60"
    And the total including taxes is "201,60"
    When he saves the quotation
    Then a message signals the success of the quotation creation
    Then I am on the created quotation
    And the quotation informations are visible on the quotation details
