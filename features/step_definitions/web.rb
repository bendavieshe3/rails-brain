# General web steps

When /^I visit the homepage$/ do
  visit "/"
end

Then(/^I should see "([^"]*)"$/) do | text |
  page.should have_content text
end