When(/^I go to the folders section$/) do
  visit dorsale.flyboy_folders_path
end

When(/^I create a new folder$/) do
  find("a[href$='folders/new']").click
  fill_in "folder_name", with: "I-am-the-folder-title"
  fill_in "folder_description", with: "I-am-the-folder-description"
  find("form[id*=folder] [type=submit]").click
end

Then(/^I am on this folder$/) do
  expect(current_path).to eq dorsale.flyboy_folder_path(@folder)
end

Then(/^I am on the created folder$/) do
  @folder = Dorsale::Flyboy::Folder.order("id DESC").first
  expect(current_path).to eq dorsale.flyboy_folder_path(@folder)
end

Then(/^the folder is created$/) do
  expect(page).to have_content "I-am-the-folder-title"
end

Then(/^the folder is opened$/) do
  expect(page).to have_content "Ouvert"
end

Given(/^an existing folder$/) do
  @folder = create(:flyboy_folder)
end

Given(/^(\d+) tasks in this folder$/) do |n|
  n.to_i.times do
    create(:flyboy_task, taskable: @folder)
  end
end

When(/^I consult this folder$/) do
  visit dorsale.flyboy_folders_path
  click_link @folder.name
end

Then(/^I see this folder$/) do
  expect(current_path).to eq dorsale.flyboy_folder_path(@folder)
  expect(page).to have_content @folder.name
  expect(page).to have_content @folder.description
  expect(page).to have_content @folder.tracking
end

Then(/^I see the folder tasks$/) do
  @folder.tasks.map do |task|
    expect(page).to have_content task.name
  end
end

When(/^I update this folder$/) do
  click_link @folder.name
  find("a[href$='folders/#{@folder.id}/edit']").click
  fill_in "folder_name", with: "New-folder-title"
  find("form[id*=folder] [type=submit]").click
end

Then(/^I am on the updated folder$/) do
  expect(current_path).to eq dorsale.flyboy_folder_path(@folder)
end

Then(/^the folder is updated$/) do
  expect(page).to have_content "New-folder-title"
end

When(/^I delete this folder$/) do
  click_link @folder.name
  find("a[href$='folders/#{@folder.id}/edit']").click
  find(".context a[data-method=delete]").click
end

Then(/^I am on the folders section$/) do
  expect(current_path).to eq dorsale.flyboy_folders_path
end

Then(/^the folder is deleted$/) do
  expect(page).to_not have_content @folder.name
end

When(/^I close this folder$/) do
  visit dorsale.flyboy_folder_path(@folder)
  find("a[href$='folders/#{@folder.id}/close']").click
end

Then(/^the folder is closed$/) do
  expect(page).to have_content "Fermé"
end

Given(/^an existing closed folder$/) do
  @closed_folder = create(:flyboy_folder, status: "closed")
  @folder = @closed_folder
end

When(/^I reopen this folder$/) do
  visit dorsale.flyboy_folder_path(@folder)
  find("a[href$='folders/#{@folder.id}/open']").click
end

Given(/^an existing open folder$/) do
  @open_folder = create(:flyboy_folder, status: "open")
  @folder = @open_folder
end

When(/^I filter folders by open$/) do
  select "Ouvert"
  find(".filters [type=submit]:last-child").click
end

Then(/^only open folders appear$/) do
    expect(page).to have_content @open_folder.name
    expect(page).to_not have_content @closed_folder.name
end

When(/^I filter folders by closed$/) do
  select Dorsale::Flyboy::Folder.t("status.closed")
  find(".filters [type=submit]:last-child").click
end

Then(/^only closed folders appear$/) do
  expect(page).to have_content @closed_folder.name
  expect(page).to_not have_content @open_folder.name
end

Then(/^all folders appear$/) do
  expect(page).to have_content @open_folder.name
  expect(page).to have_content @closed_folder.name
end

Given(/^an existing folder named "(.*?)"$/) do |name|
  create(:flyboy_folder, name: name)
end

Then(/^only the "Hello" folder appear$/) do
  expect(page).to have_content "Hello"
  expect(page).to_not have_content "World"
end

Given(/^(\d+) existing folders$/) do |n|
  n.to_i.times do
    create(:flyboy_folder)
  end
end

Then(/^folders are paginated$/) do
  expect(all("tr.folder").count).to eq 50
  expect(page).to have_selector ".pagination"
end

Given(/^(\d+) tasks to sort in this folder$/) do |n|
  n.to_i.times do
    create(:flyboy_task, taskable: @folder)
  end
end

When(/^I sort tasks by "(.*?)" "(.*?)"$/) do |column, direction|
  sort = direction == "desc" ? "-#{column}" : "#{column}"
  visit dorsale.flyboy_folder_path(@folder, sort: sort)
end

Then(/^tasks are sorted by "(.*?)" "(.*?)"$/) do |column, direction|
  page_names    = all("tbody td.task-name").map(&:text)
  expected_name = @folder.tasks.reorder(column => direction).pluck(:name)
  expect(page_names).to eq expected_name
end
