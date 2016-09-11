@javascript
Feature: IdCards

  Scenario: New id_card
    Given an authenticated user
    And the user goes on the new id_card page
    When he fills the id_card's information
    And creates a new id_card
    Then he is redirected on the id_cards page
    And the id_card is added to the id_card list

  Scenario: Update id_card
    Given an authenticated user
    And an existing id_card
    When the user edits the id_card
    Then the current id_card's label should be pre-filled
    When he validates the new id_card
    Then he is redirected on the id_cards page
    And the id_card's label is updated
