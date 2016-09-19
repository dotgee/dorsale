@javascript
Feature: Manage corporations
  As a user
  I want to edit corporations
  In order to track oppotunities of business

  Background:
    Given an authenticated user

  Scenario: New corporation
    When I create an new corporation
    And I add the corporation's informations
    And I fill the corporation's address
    And I fill the corporation capital, immatriculation1, immatriculation2, legal form
    And I validate the new corporation
    Then the corporation is created
    And I am on the corporation page

  Scenario: Add tags
    Given an existing corporation
    When I edit this corporation
    And I add tags to this corporation
    And I submit this corporation
    Then tags are added

  Scenario: Remove tags
    Given an existing corporation with tags
    When I edit this corporation
    And I remove tags to this corporation
    And I submit this corporation
    Then tags are removed

  Scenario: Pagination corporation by 25
    Given 40 existing corporations
    When I go on the corporate index
    Then he can see 25 corporate
    When he go on the next page
    Then he can see 15 corporate

  Scenario: New person without name
    When I create an new corporation
    And I fill the corporation's address
    And I validate the new corporation
    Then i see an error message for the missing name

  Scenario: Add a comment to a corporation
    Given an existing corporation
    When I go on this corporation
    And I add a comment
    Then I am on the corporation page
    And I see my new comment

  Scenario: Update comment on a corporation
    Given an existing corporation
    And an existing comment on this corporation
    When I go on this corporation
    And I update the comment
    Then I am on the corporation page
    And I see my updated comment

  Scenario: Delete comment on a corporation
    Given an existing corporation
    And an existing comment on this corporation
    When I go on this corporation
    And I delete the comment
    Then I am on the corporation page
    And I see do not see my comment

  Scenario: People activity
    Given an existing individual with recent comments
    Given an existing corporation with recent comments
    When I go on the people activity
    Then I see all these comments

  Scenario: People activity
    Given an existing corporation with 150 comments
    When I go on the people activity
    Then I see these comments paginated

  Scenario: Context
    Given an existing corporation
    And an open task to this corporation
    And a closed task to this corporation
    And an existing individual
    And a link between this individual and this corporation
    When I go on this corporation
    Then I see only the open task in the context
    And I see the link in the context
