module ApplicationHelper

  def common_title 
    'My Web Brain'
  end

  def title(page_title, embelish=true)
    provide :title, if embelish 
      "#{page_title} | #{common_title}" 
    else
      page_title.to_s
    end
  end


end
