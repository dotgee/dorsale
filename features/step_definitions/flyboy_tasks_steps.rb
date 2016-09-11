# encoding: utf-8
require "rake"

Given(/^an existing done task$/) do
  @done_task = create(:flyboy_task, done: true)
end

Given(/^an existing undone task$/) do
  @undone_task = create(:flyboy_task, done: false)
end

Given(/^an existing task named "(.*?)"$/) do |name|
  create(:flyboy_task, name: name)
end

Given(/^an existing task$/) do
  @task   = create(:flyboy_task)
  @folder = @task.taskable
end

Given(/^an existing snoozable task$/) do
  create(:flyboy_task,
    :reminder => Date.yesterday,
    :term     => Time.zone.now.to_date
  )
end

Given(/^(\d+) existing tasks$/) do |n|
  n.to_i.times do
    create(:flyboy_task)
  end
end

Given(/^a task with an owner that's the term is today$/) do
  @task = create(:flyboy_task,
    :reminder => Date.yesterday,
    :term     => Time.zone.now.to_date,
    :owner    => create(:user),
  )
end

Given(/^a task without owner$/) do
  @task = create(:flyboy_task,
    :reminder => Date.yesterday,
    :term     => Time.zone.now.to_date,
    :owner    => nil,
  )
end

Given(/^a closed task with an owner$/) do
  @task = create(:flyboy_task,
    :reminder => Date.yesterday,
    :term     => Time.zone.now.to_date,
    :owner    => create(:user),
    :progress => 100,
    :done     => true,
  )
end

When(/^the flyboy daily crons run$/) do
  ActionMailer::Base.deliveries.clear
  Dorsale::Flyboy::TaskCommands.send_daily_term_emails!
end

When(/^I create a task$/) do
  all("a[href*='tasks/new']").first.click
  find("[type=submit]").click # First submit to see errors
  fill_in "task_name", with: "I-am-the-task-title"
  fill_in "task_description", with: "I-am-the-task-description"
  select @user.name
  find("form[id*=task] [type=submit]").click
end

When(/^I go to the tasks section$/) do
  visit dorsale.flyboy_tasks_path
end

When(/^I consult this task$/) do
  click_link @task.name
end

When(/^I update this task$/) do
  visit dorsale.flyboy_task_path(@task)
  find("a[href$='tasks/#{@task.id}/edit']").click
  fill_in "task_name", with: "New-task-title"
  find("form[id*=task] [type=submit]").click
end

When(/^I complete this task$/) do
  find("a[href$=complete]").click
end

When(/^I snooze this task$/) do
  find("a[href*=snooze]").click
end

When(/^I export tasks to PDF$/) do
  find("a[href$=pdf]").click
end

When(/^I export tasks to CSV$/) do
  find("a[href$=csv]").click
end

When(/^I export tasks to XLS$/) do
  find("a[href$=xls]").click
end

When(/^I filter tasks by done$/) do
  select "Fermé"
  find(".filters [type=submit]:last-child").click
end

When(/^I filter tasks by undone$/) do
  select "Ouvert"
  find(".filters [type=submit]:last-child").click
end

When(/^I reset filters$/) do
  find(".filters .reset").click
end

When(/^I delete this task$/) do
  visit dorsale.flyboy_task_path(@task)
  find("a[href$='tasks/#{@task.id}/edit']").click
  find(".context a[data-method=delete]").click
end

Then(/^I am on the created task$/) do
  @task = Dorsale::Flyboy::Task.order("id DESC").first
  expect(current_path).to eq dorsale.flyboy_task_path(@task)
end

Then(/^the task is created$/) do
  expect(page).to have_content "I-am-the-task-title"
end

Then(/^I see this task$/) do
  expect(current_path).to eq dorsale.flyboy_task_path(@task)
end

Then(/^I am on the updated task$/) do
  expect(current_path).to eq dorsale.flyboy_task_path(@task)
end

Then(/^the task is updated$/) do
  expect(page).to have_content "New-task-title"
end

Then(/^I am on the tasks section$/) do
  expect(current_path).to eq dorsale.flyboy_tasks_path
end

Then(/^the task is deleted$/) do
  expect(page).to_not have_content @task.name
end

Then(/^the task is completed$/) do
  expect(page).to have_content "100%"
end

Then(/^the task is snoozed$/) do
  expect(all("a[href*=snooze]").count).to eq 0
end

Then(/^I download PDF file$/) do
  expect(page.status_code).to eq 200
  expect(page.response_headers['Content-Type']).to match "application/pdf"
end

Then(/^I download CSV file$/) do
  expect(page.status_code).to eq 200
  expect(page.response_headers['Content-Type']).to match "text/csv"
end

Then(/^I download XLS file$/) do
  expect(page.status_code).to eq 200
  expect(page.response_headers['Content-Type']).to match "excel"
end

Then(/^I am on this task$/) do
  expect(current_path).to eq dorsale.flyboy_task_path(@task)
end

Then(/^only done tasks appear$/) do
  expect(page).to have_content @done_task.name
  expect(page).to_not have_content @undone_task.name
end

Then(/^only undone tasks appear$/) do
  expect(page).to_not have_content @done_task.name
  expect(page).to have_content @undone_task.name
end


Then(/^all tasks appear$/) do
  expect(page).to have_content @done_task.name
  expect(page).to have_content @undone_task.name
end

Then(/^only the "Hello" task appear$/) do
  expect(page).to have_content "Hello"
  expect(page).to_not have_content "World"
end

Then(/^tasks are paginated$/) do
  expect(all("tr.task").count).to eq 50
  expect(page).to have_selector ".pagination"
end

Then(/^no email is sent$/) do
  expect(ActionMailer::Base.deliveries.count).to eq 0
end

Then(/^the owner receive an email$/) do
  expect(ActionMailer::Base.deliveries.count).to eq 1
  email = ActionMailer::Base.deliveries.last
  expect(email.to).to include @task.owner.email
end
