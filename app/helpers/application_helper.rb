module ApplicationHelper

  def base_title 
    'My Web Brain'
  end

  def page_title
    @page_title
  end

  def embelish_page_title; @embelish_page_title; end

  def full_title
    if page_title and embelish_page_title
      "#{page_title} | #{base_title}"
    elsif page_title
      page_title
    else
      base_title
    end
  end

  def title(page_title, embelish_page_title=true)
    @page_title = page_title
    @embelish_page_title = embelish_page_title
  end

end
