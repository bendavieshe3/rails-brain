class ActionsPage < WebBasePage

  PAGE_URI_PATH = '/tasks'

  SELECTORS = {
    page_check_element: '#actions-page',
    actions_table: '#actions'
  }

  def ok?
    fail "Missing the word 'Actions'" unless @session.has_content? 'Actions'
  end

end
