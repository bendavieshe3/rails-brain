RSpec::Matchers.define :have_heading do | text |

  match do |actual|
    page.has_selector?('h1,h2,h3', text:text)
  end

  failure_message_for_should do |actual|
    message = "Does not have a heading including '#{text}'"
  end

  failure_message_for_should_not do |actual|
    message = "have a heading including '#{text}'"
  end 

  description do 
    message = "have a heading including '#{text}'"
  end

end