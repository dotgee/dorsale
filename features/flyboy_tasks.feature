@javascript
Feature: Manage tasks
  Background:
    Given an authenticated user

  Scenario: Create a task
    Given an existing folder
    When I consult this folder
    And I create a task
    Then I am on this folder
    And the task is created

  Scenario: Read a task
    Given an existing task
    When I go to the tasks section
    And I consult this task
    Then I see this task

  Scenario: Update a task
    Given an existing task
    When I go to the tasks section
    And I update this task
    Then I am on the updated task
    And the task is updated

  Scenario: Delete a task
    Given an existing task
    When I go to the tasks section
    And I delete this task
    Then I am on the tasks section
    And the task is deleted

  Scenario: Complete a task
    Given an existing task
    When I go to the tasks section
    And I complete this task
    Then I am on the tasks section
    And the task is completed

  Scenario: Snooze a task
    Given an existing snoozable task
    When I go to the tasks section
    And I snooze this task
    Then I am on the tasks section
    And the task is snoozed

  Scenario: Export tasks to PDF
    Given 3 existing tasks
    When I go to the tasks section
    And I export tasks to PDF
    Then I download PDF file

  Scenario: Export tasks to CSV
    Given 3 existing tasks
    When I go to the tasks section
    And I export tasks to CSV
    Then I download CSV file

  Scenario: Export tasks to XLS
    Given 3 existing tasks
    When I go to the tasks section
    And I export tasks to XLS
    Then I download XLS file

  Scenario: Filter tasks
    Given an existing done task
    And an existing undone task
    When I go to the tasks section
    And I filter tasks by done
    Then only done tasks appear
    When I filter tasks by undone
    Then only undone tasks appear
    When I reset filters
    Then all tasks appear

  Scenario: Search tasks
    Given an existing task named "Hello"
    And an existing task named "World"
    When I go to the tasks section
    And I search "Hello"
    Then only the "Hello" task appear

  Scenario: Tasks pagination
    Given 100 existing tasks
    When I go to the tasks section
    Then tasks are paginated

  Scenario: Term email with owner
    Given a task with an owner that's the term is today
    When the flyboy daily crons run
    Then the owner receive an email

  Scenario: Term email without owner
    Given a task without owner
    When the flyboy daily crons run
    Then no email is sent

  Scenario: Term email for closed task
    Given a closed task with an owner
    When the flyboy daily crons run
    Then no email is sent
