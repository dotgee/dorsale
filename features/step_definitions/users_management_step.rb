When(/^he goes to the users section$/) do
  visit dorsale.users_path
end

When(/^he creates a new user$/) do
  find("[href$='users/new']").click
  fill_in "user_email", with: "toto@toto.fr"
  find("[type=submit]").click
end

Then(/^the user is visible in the user list$/) do
  expect(page).to have_content I18n.t("messages.users.create_ok")
  expect(page).to have_content "toto@toto.fr"
end

When(/^he click on update user button$/) do
  expect(page).to have_content @user.email
  find("#main [href$=edit]").click
end

When(/^he update the user$/) do
  fill_in "user_email", with: "toto@toto.fr"
  find("[type=submit]").click
end

Then(/^the user's new informations are visible in the users list$/) do
  expect(page).to have_content I18n.t("messages.users.update_ok")
  expect(page).to have_content "toto@toto.fr"
end
