# Generic Step Definitions for writing Web Functional Tests using the Functionary Web Page Model
require 'uri'

# Page Navigation

Given /^I (?:am on|visit) the (#{WORDS}) [P|p]age$/ do |page_name|
  #Cucumber seems to sometimes have problems capturing multiple words outside of strings
  #here we used the WORDS capture pattern (defined in general_captures.rb) to get around
  #the issue
  @page = WebBasePage.page(page_name)
  @page.visit
end

When /^I navigate to the (#{WORDS})$/ do |page_name|
  @page = WebBasePage.page(page_name)
  @page.navigate_to
end

# Paging 

Given /^I go to the (#{WORD}) page$/ do |page|
  #Eg I go to the last page
  #TODO: This step should be refactored into the page model since it is dependent on
  #the implementation detail about how paging is implemented or marked up.
  click_link(page)
end

# Page Assertions

Then /^I (?:should be on|am taken to) the (#{WORDS}) [P|p]age$/ do | page_name |
  @page = WebBasePage.page(page_name)
  @page.correct_page?
end

Then /^the page should look ok$/ do 
  @page.ok?
end

Then /^I should( not)? see the (#{WORDS}) on the page$/ do |do_not_want, name|
  if do_not_want
    page.should have_no_selector(@page.selector(name))
  else
    page.should have_selector(@page.selector(name))
  end
end

Then /^there should be (many|no) (#{WORD}) (?:displayed|listed|shown)$/ do | quantifier, collection |
  collection = @page.send(collection.to_sym)
  number_of_items = collection.length

  case quantifier.downcase
  when 'many'
    fail "There are only #{number_of_items} found (expect many)" if number_of_items < 2
  when 'no'
    fail "There were #{number_of_items} found (expect none)" if number_of_items > 0
  else
    fail "I don't understand quantifier '#{quantifier}'"
  end
end

Then /^the (#{WORD}) (#{WORD})? (#{QUOTED_STRING}) should( not)? be listed under (#{WORD})$/ do | field_name_1, field_name_2, value, do_not_want, collection_name |
  collection = @page.send(collection_name.to_sym)

  #TODO: Implement a basic synonym feature in pages to allow more flexibility here
  #TODO: allow f1, f2 and f1_f2 field_name combinations
  #TODO: deal with case sensitivity in values, possible contains semantics etc

  if collection.empty?
    fail("There are is nothing listed under #{collection_name}")
  elsif field_name_2.nil?
    field_name = field_name_1.downcase
  else
    field_name = field_name_2.downcase
  end

  #check that the field is defined
  field_names = collection[0].keys
  fail("""field '#{field_name}' does not appear to be defined in #{collection_name}
    fields: #{field_names}""") unless field_names.include? field_name

  found = collection.any? do | item |
    item[field_name] == value
  end

  if do_not_want
    fail("#{field_name} '#{value}' found in #{collection_name}") if found
  else
    fail("#{field_name} '#{value}' not found in #{collection_name}") unless found
  end

end

# Assertions
Then /^It should have at least (#{CAPTURE_NUMBER}) rows?$/ do | num_rows |
  page.should have_selector('tr', :count => num_rows + 1) # Adds 1 due to the header 'TR' row
end

#improve. We should have a way to use the page element name to narrow down the check
Then /^I should( not)? see (#{QUOTED_STRING}) on the page$/ do |do_not_want, content|
  if do_not_want
    page.should have_no_content(content)
  else
    page.should have_content(content)
  end
end

Then /^I should not see (.+)$/ do |x|
  #TODO: This is too vague
  page.should have_no_link(x)
end

# Page interactions

When /^I search for (#{WORD}) (#{QUOTED_STRING})$/ do | domain, search_term | 
  @page.search_for(search_term, domain)
end

When /^I (edit|create|delete) the (#{WORD}) (#{WORD})$/ do | verb, name, domain |

  # Dynamically call a edit/create/delete etc method on the page object
  # This method call could change the page we are on, so it is responsible for
  # returning the correct page.

  instance_method_name = "#{verb}_#{domain}"
  if @page.class.instance_methods.include? instance_method_name.to_sym
    @page = @page.send(instance_method_name.to_sym, name) || @page
    @page.correct_page?
  else
    fail "There is not method #{instance_method_name} defined on #{@page.class.name}."
  end

end


# Other interations

When /^I access "(.*?)"$/ do |link|
  #TODO: This is too vague
  click_link(link)
end

When /^I click on the (#{QUOTED_STRING}) button(?: and wait for (.+))?$/ do |button_text, wait_content|
  #TODO: Need to confirm this works for any situation
  click_link_or_button(button_text)
  if wait_content
    wait_until{page.should have_content(wait_content)}
  end  
end

When /^I click on the (#{WORDS}) button(?: and wait for (.+))?$/ do |button_selector_id, wait_content|
  #TODO: This currently only works with IDs. check to see if the selector
  # is an ID or not and choose between xpath and normal implementation
  # (xpath below will not work for non-IDs!)

  selector = @page.selector(button_selector_id + ' button')
  selector = selector_to_dumb_string(selector)
  find(:xpath, "id('#{selector}')").click
  if wait_content
    wait_until{page.should have_content(wait_content)}
  end  
end

When /^I click on the (#{WORDS}) button to open a new window$/ do |button_selector_id|
  # Click a button to open a new window. Switch to it. Confirm it is new
  #TODO: Cleanup, generalise and incorporate into step above (for wait content etc)
  #DEMO: Confirming new windows and tabs open

  start_window = @page.session.driver.browser.window_handles.last

  selector = @page.selector(button_selector_id + ' button')
  selector = selector_to_dumb_string(selector)
  find(:xpath, "id('#{selector}')").click
  
  end_window = @page.session.driver.browser.window_handles.last
  @page.session.driver.browser.switch_to.window(end_window)

  fail "A new window or tab was not opened" if start_window == end_window
end

#TODO: Deprecated!
#NOTE: Use this step when the ID is embedded and the above step doesn't detect it.
#NOTE: waiting for all javascript action to load.
When /^I click on the button id (.+)(?: and wait for (.+))?$/ do |button_id, wait_content|
  find(:xpath, "id('#{button_id}')").click
  if wait_content
    wait_until{page.should have_content(wait_content)}
  end
end

#TODO: No idea where the below is used for 
When /^I follow the (.+) link for (.*?)$/ do |button_type, name|
  click_link(name)
  click_link(button_type)
end

When /^I follow the link to (.+)$/ do | link |
  click_link(link)
end




