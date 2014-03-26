module Helpers

  def sign_in_as_a_user(user)

    visit signup_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "foobar"
    fill_in "Confirmation", with: "foobar"
    click_button "Create my account"    

  end

end