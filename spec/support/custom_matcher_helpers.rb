
def found_selector(*selectors)
  selectors.detect do |selector|
    page.has_selector?(selector)
  end
end
