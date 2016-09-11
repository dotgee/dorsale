@javascript
Feature: Expense Categories

  Scenario: New expense category
    Given an authenticated user
    And the user goes on the new expense category page
    When he fills the category's information
    And creates a new expense category
    Then he is redirected on the expense categories page
    And the category is added to the category list

  Scenario: Update expense category
    Given an authenticated user
    And an existing expense category
    When I edit the expense category
    Then the current expense category's label should be pre-filled
    When he validates the new expense category
    Then he is redirected on the expense categories page
    And the expense category's label is updated
