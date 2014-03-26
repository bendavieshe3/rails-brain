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
    @element = element.to_s.gsub('_','-')
    @id_selector = "#{@tag_type}\##{@element}"
    @class_selector = "#{@tag_type}.#{@element}"

    @found_selector = found_selector(@id_selector, @class_selector)

    if @found_selector.nil?
      false
    elsif @things_to_count.nil?
      true
    else
      page.find(:css, @found_selector).has_css?(@thing_to_count, count: @count)
    end
  end

  chain :table do
    @tag_type = 'table'
  end

  chain :section do
    @tag_type = 'div'
  end

  chain :with do | number |
    @count = number
  end

  chain :rows do | number |
    @thing_to_count = "tbody tr"
  end

  failure_message_for_should do |actual|
    message = "Element '#{@id_selector}' or '#{@class_selector}' was not " + 
      "found on the page"
  end

  failure_message_for_should_not do |actual|
    message = "Element '#{@id_selector}' or '#{@class_selector}' was " + 
      "found on the page"
  end 

  description do 
    message = "have an element '#{@id_selector}' or '#{@class_selector}'"
  end
end


RSpec::Matchers.define :have_an_alert  do 

  match do | actual |
    @selector = ".alert"
    @selector = ".alert.alert-#{@type}" if @type
    page.has_selector? @selector
  end

  chain :of_type do | type |
    @type = type
  end

  failure_message_for_should do |actual|
    message = "Could not find an alert as described on the page (looking for " +
      "#{@selector})."
  end

  failure_message_for_should_not do |actual|
    message = "Found an alert as described on the page"
  end 

  description do 
    message = "have an alert (with class .alert)"
  end
end

RSpec::Matchers.define :have_text  do | text |

  match do | actual |
    container = page
    if @container 
      container_selector = found_selector('#' + @container, '.' + @container)
      container = page.find(:css, container_selector )
    end
    container.has_content? text
  end

  chain :in do | container |
    @container = container.to_s.gsub('_','-')
  end

  failure_message_for_should do |actual|
    message = "Could not find text '#{text}'"
    message += " in container '#{@container}'." if @container
  end

  failure_message_for_should_not do |actual|
    message = "Found text '#{text}'"
    message += " in container '#{@container}'." if @container
  end 

  description do 
    message = "have provided text '#{text}'"
    message += " in container '#{@container}'" if @container
  end
end


