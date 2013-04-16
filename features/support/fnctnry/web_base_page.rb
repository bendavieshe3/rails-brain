class WebBasePage
  include Capybara::DSL
  include Capybara::Node::Matchers
  include RSpec::Matchers

  # Constructors and Factory Methods

  def self.page(page_name)
    page_class_name = page_name.gsub(" ","")
    if not page_class_name =~ /Page$/
      page_class_name += "Page"
    end
    Object.const_get(page_class_name).new(Capybara.current_session) 
  end

  def initialize(session)
    @session = session
    check_required_base_page_constants('PAGE_URI_PATH','SELECTORS')
  end


  # Navigation

  def navigate_to
    #TODO: fix the below so it reliably works for any number of pages, where this
    # page only knows the page immediately prior to navigating to this page. If it
    # does not know that page it visited directly (ie. operates recursively)    
    if self.nav_path
      @parent_page = BasePage.page(self.nav_path[:from])
      @parent_page.visit
      @session.click_link(self.nav_path[:link])
      if self.nav_path[:link2]
      @session.click_link(self.nav_path[:link2])
    else
    end
      correct_page?
    else
      self.visit
    end
  end

  def visit
    #TODO: some pages have parameters in their URL, and can't be visited
    # detect and handle here
    # 1. raise an error with a meaning explanation
    # 2. possibly support some application introspection to visit a random product details page
    @session.visit location
    correct_page?
  end


  # Current Page Checks 

  def correct_page?
    # fails if this is not the correct page.
    # override this method for difficult pages without good selector elements.

    if selector? :page_check_element
      element :page_check_element
    else
      warning "Could not check correct page (page check element not defined)"
    end
  rescue Capybara::ElementNotFound => error
    fail """Not on expected page. Current driver location is #{current_url}, looking for #{selector(:page_check_element)}"""
  end

  def ok?
    # override this method on subclasses
    fail """
      ok check not implemented on this object. To fix, override ok? method for this page and
      fail if not ok.
      """
  end

  # Interactions

  def search_for(search_term, domain)

    domain_prefix = domain ? "#{domain.downcase}_" : ""

    search_textbox_selector = selector "#{domain_prefix}search_text"
    search_button_selector = selector "#{domain_prefix}search_button"

    fill_in(selector_to_dumb_string(search_textbox_selector), :with => search_term)
    click_button(search_button_selector)
  end

  # Current Page Properties

  def current_url
    @session.current_url
  end

  def session
    @session
  end

  def element(selector_id)
    # Returns the element on the page corresponding to the named selector
    # Importantly we do not want to the calling code to specify a raw selector
    @session.find(selector(selector_id))
  end

  def element_exists?(selector_id)
    @session.has_selector(selector(selector_id))
  end

  def section(selector_id)
    # Synonym for element()
    element(selector_id)
  end

  def table_data(table_selector_id, raw_header_selector, raw_row_selector)
    #TODO: allow table_element to be a real DOM element or a named element
    #TODO: need to make allowances for multiple header rows
    #TODO: add optional page navigation to view all result pages
    #TODO: slow... add lazy loading for simple tests like count etc?

    table = element(table_selector_id)
    header_list = table.all(raw_header_selector).map { |h| h.text.downcase   }
    table.all(raw_row_selector).map do |row|
      row_values = row.all('td').map { |cell| cell.text }
      Hash[header_list.zip(row_values)] # returns {"header1" => "value1", etc}
    end #returns [{row1},{row2}]
  end  

  #TODO: Add a single and multi-value properties that can be inspected with generic methods.
  # eg. About Page has a page.version reflecting the version seen on the page.
  # eg. Device page has a page.devices collection, which can lazily summarise results across
  #     pages.
  # Steps would be generic in web.rb
  # eg. Then the page version should be ""
  # eg. Then the page devices should include ""  

  # Page Model Properties

  def page_path
    self.class::PAGE_URI_PATH
  end

  def location
    # synonym for page_page
    page_path
  end

  def selectors 
    self.class::SELECTORS
  end

  def selector?(selector_id)
    # Return TRUE if selector_id is defined for the current page.
    # note that all datatypes are coerced to symbols for comparison
    not selectors[sanitise_selector_id(selector_id)].nil?
  end

  def selector(selector_id)
    # Return the named selector defined in the page selector table
    # selector_id is coerced to a symbol and an error is raised if the selector_id
    # is not found
    selector = selectors[sanitise_selector_id(selector_id)]
    unless selector
      raise "Selector ID '#{sanitise_selector_id(selector_id).to_s}' has not been defined in the page model #{self.class.name}"
    end

    # We want to intepolate selectors with current page information where required(eg use process ID in the selector where required)
    # Eg. :process_mapping_button => "#my-poorly-named-button-<%= process_id %>" should call page method process_id() to resolve {process_id}
    # placeholder
    selector = ERB.new(selector).result(binding)

    #TODO: We want to allow optional selector_id domains 
    # A selector id might be prefixed with a domain_name eg :PROCESSES_NAME_COLUMN
    # We want to first check :PROCESSES_NAME_COLUMN exists, and if not, check :NAME_COLUMN and return that if found

    selector 
  end

  # Page Model Checks

  def check_required_base_page_constants(*list)
    # Given a list of constant names, ensures all are defined for this class
    # Use to help guide people to using the page object correctly. 
    list.each do | constant_name |
      if not self.class.const_defined? constant_name
        #DEMO: Good error message
        raise "You must define constant #{constant_name} in your page #{self.class.name}."
      end
    end
  end

  # helpers
  
  def sanitise_selector_id(selector_id)
    # takes a string selector id and turns it into a possibly valid selectorId. Replaces spaces
    # with underscores
    selector_id.to_s.downcase.gsub(' ', '_').to_sym
  end
end
