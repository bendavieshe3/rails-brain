RSpec::Matchers.define :have_heading do | text |

  match do |actual|
    page.has_selector?('h1,h2,h3', text:text)
  end

  failure_message_for_should do |actual|
    message = "Does not have a heading including '#{text}'. " +
      "(Document title: #{page.title})"
  end

  failure_message_for_should_not do |actual|
    message = "have a heading including '#{text}'"
  end 

  description do 
    message = "have a heading including '#{text}'"
  end

end

RSpec::Matchers.define :have_the_focus do 

  match do | actual |
    id = actual[:id]
    browser_active_id = page.evaluate_script("document.activeElement.id") 
    raise 'No id found on element' unless id
    id == browser_active_id
  end

  failure_message_for_should do |actual|
    message = "Element #{actual[:id]} does not have focus"
  end

  failure_message_for_should_not do |actual|
    message = "Element #{actual[:id]} has focus"
  end 

  description do 
    message = "have focus"
  end
end


RSpec::Matchers.define :have_a  do | element | 

  match do | actual |
    @selector = "#{@tag_type}\##{element.to_s}"
    @found_element = page.find(:css, @selector) 
    if @thing_to_count.nil?
      #simple match
      @found_element
    else
      @found_element && @found_element.has_css?(@thing_to_count, count: @count)
    end
  end

  chain :table do
    @tag_type = 'table'
  end

  chain :with do | number |
    @count = number
  end

  chain :rows do | number |
    @thing_to_count = "tbody tr"
  end

  failure_message_for_should do |actual|
    message = "Element .#{element.to_s} was not found on the page"
  end

  failure_message_for_should_not do |actual|
    message = "Element .#{element.to_s} was found on the page"
  end 

  description do 
    message = "have an element .#{element.to_s}"
  end
end