Given(/^an expired tasks$/) do
  @task = create(:flyboy_task, taskable: @folder, owner: @user, term: Time.zone.now.to_date-1)
end

Given(/^a task that expire tommorow$/) do
 @task = create(:flyboy_task, taskable: @folder, owner: @user, term: Time.zone.now.to_date+1)
end

Given(/^a task that expire today$/) do
  @task = create(:flyboy_task, taskable: @folder, owner: @user, term: Time.zone.now.to_date)
end

When(/^he go to the tasks summary page$/) do
  visit dorsale.summary_flyboy_tasks_path
end

Then(/^the task is classed as 'expired'$/) do
  expect(page).to have_content("En retard")
  expect(page).to have_content(@task.name)
end

Then(/^the task is classed as 'Expire Today'$/) do
  expect(page).to have_content("Aujourd'hui")
  expect(page).to have_content(@task.name)
end

Then(/^the task is classed as 'Expire tommorow'$/) do
  expect(page).to have_content("Demain")
  expect(page).to have_content(@task.name)
end
