@javascript
Feature: Expenses
  Background:
    Given an authenticated user
    And an existing expense category

  Scenario: Create expense
    When I go on the expenses page
    Then I see 0 expense
    When I create a new expense
    Then the expense is created
    And I am redirected on the expense page
    And I see 2 expense lines
    When I go on the expenses page
    Then I see 1 expense

  Scenario: Update expense
    Given an existing expense
    When I go on the expenses page
    Then I see 1 expense
    When I update the expense
    Then the expense is update
    And I am redirected on the expense page

  Scenario: Copy expense
    Given an existing expense
    When I go on the expense page
    When I copy the expense
    Then an expense copy is created
    And I am redirected on the expense page

  Scenario: Submit expense
    Given an existing expense
    When I go on the expense page
    And I submit the expense
    Then I am redirect to the expenses page
    And the expense state is "submited"

  Scenario: Cancel expense
    Given an existing expense
    When I go on the expense page
    And I cancel the expense
    Then I am redirect to the expenses page
    And the expense state is "canceled"

  Scenario: Accept expense
    Given an existing expense
    And the expense is submited
    When I go on the expense page
    And I accept the expense
    Then I am redirect to the expense page
    And the expense state is "accepted"

  Scenario: Refuse expense
    Given an existing expense
    And the expense is submited
    When I go on the expense page
    And I refuse the expense
    Then I am redirect to the expenses page
    And the expense state is "refused"
