@javascript
Feature: PaymentTerm

  Scenario: New payment_term
    Given an authenticated user
    And the user goes on the new payment_term page
    When he fills the payment_term's information
    And creates a new payment_term
    Then he is redirected on the payment_terms page
    And the payment_term is added to the payment_term list

  Scenario: Update payment_term
    Given an authenticated user
    And an existing payment_term
    When the user edits the payment_term
    Then the current payment_term's label should be pre-filled
    When he validates the new payment_term
    Then he is redirected on the payment_terms page
    And the payment_term's label is updated
