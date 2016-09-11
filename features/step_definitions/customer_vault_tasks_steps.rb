When(/^I go on the tasks section$/) do
  find("a[href='#tasks']").click
end

When(/^I create a task on this person$/) do
  @tasks_count = ::Dorsale::Flyboy::Task.count
  find("#tasks a[href*='tasks/new']").click
  fill_in :task_name, with: "YepYep"
  fill_in :task_description, with: "Trololo"
  find("[type=submit]").click
end

Then(/^the person task is created$/) do
  expect(::Dorsale::Flyboy::Task.count).to eq(@tasks_count + 1)
  @task = ::Dorsale::Flyboy::Task.order(:id).last

  if @corporation
    url = dorsale.customer_vault_corporation_path(@corporation)
  elsif @individual
    url = dorsale.customer_vault_individual_path(@individual)
  else
    raise "invalid person"
  end

  expect(current_path).to eq url
end

Then(/^the task appear$/) do
  expect(page).to have_content "YepYep"
end

When(/^I go on the general tasks page$/) do
  visit dorsale.flyboy_tasks_path
end

When(/^I filter tasks$/) do
  find(".filter-submit").click
end

Then(/^I an redirected on the tasks tab$/) do
  expect(current_path).to eq dorsale.customer_vault_individual_path(@individual)
  hash = page.evaluate_script("location.href").split("#").last
  expect(hash).to eq "tasks"
end
