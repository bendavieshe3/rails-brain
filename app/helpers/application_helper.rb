module ApplicationHelper

  def base_title 
    'My Web Brain'
  end

  def heading
    @heading
  end

  def tagline
    @tagline
  end

  def suppress_heading?
    @suppress_heading
  end

  def embelish_page_title; @embelish_page_title; end

  def page_title
    if heading and embelish_page_title
      "#{heading} | #{base_title}"
    elsif heading
      heading
    else
      base_title
    end
  end

  def title(heading, tagline:nil, embelish_page_title:true, suppress_heading:false)
    @heading = heading
    @tagline = tagline
    @embelish_page_title = embelish_page_title
    @suppress_heading = suppress_heading
  end

end
