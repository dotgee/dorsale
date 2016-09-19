Lorsqu(/^he go to the people list$/) do
  visit dorsale.customer_vault_people_path
end

Etantdonné(/^existing individuals$/) do
  @individual1 = create(:customer_vault_individual, first_name: "Jean", last_name: "DUPONT")
  @individual2 = create(:customer_vault_individual, first_name: "Laurent", last_name: "DURAND")
end

Etantdonné(/^existing corporations$/) do
  @corporation1 = create(:customer_vault_corporation, name: "aaa", email: "contact@aaa.com")
  @corporation2 = create(:customer_vault_corporation, name: "zzz", email: "contact@zzz.com")
end

Lorsqu(/^he search an individual by first name$/) do
  fill_in "q", with: "Jean"
end

Alors(/^this individual appear in search results$/) do
  find(".search [type=submit]").click
  expect(page).to have_content "Jean"
  expect(page).to have_content "DUPONT"
end

Alors(/^other individuals do not appear in search results$/) do
  expect(page).to_not have_content "Laurent"
  expect(page).to_not have_content "DURAND"
end

Lorsqu(/^he search an individual by last name$/) do
  fill_in "q", with: "DUPONT"
end

Lorsqu(/^he search a corporation by name$/) do
  fill_in "q", with: "aaa"
end

Alors(/^this corporation appear in search results$/) do
  find(".search [type=submit]").click
  expect(page).to have_content "aaa"
  expect(page).to have_content "contact@aaa.com"
end

Alors(/^other corporations do not appear in search results$/) do
  expect(page).to_not have_content "zzz"
  expect(page).to_not have_content "contact@zzz.com"
end
