@javascript
Feature: Manage individuals
  As a user
  I want to edit individuals
  In order to follow up on the relationship

  Background:
    Given an authenticated user

  Scenario: New individual
    When I create an new individual
    And I add his first_name, last_name and email
    And I fill the address
    And I validate the new individual
    Then the individual is created

  Scenario: New individual without individual
    When I create an new individual
    And I fill the address
    And I validate the new individual
    Then i see an error message for the missing names

  Scenario: Add tags
    Given an existing individual
    When I edit this individual
    And I add tags to this individual
    And I submit this individual
    Then tags are added

  Scenario: Remove tags
    Given an existing individual with tags
    When I edit this individual
    And I remove tags to this individual
    And I submit this individual
    Then tags are removed
