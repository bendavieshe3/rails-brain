require 'spec_helper'

describe "User Pages" do
  subject { page }

  describe "signup page " do
    before { visit signup_path }

    let(:title) { "Sign up | #{common_part_of_title}" }
    let(:heading) { "Sign up for My Web Brain" }
    it_should_behave_like "all pages"

    it "should have an input field selected", js: true do
      input("Email").should have_the_focus
    end

    describe "signup process" do 

      let(:submit) { "Create my account" }

      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end

        it "should show error messages describing what needs to be fixed" do
          click_button submit
          page.should have_a(:error_explanation).section
        end

      end

      describe "with valid information" do
        before do
          fill_in "Email", with: "user@example.com"
          fill_in "Password", with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end

        # TODO: This needs to be changed to the Today page
        it "should create a user" do
          expect { click_button submit }.to change(User,:count).by(1)
        end

        it "should take the user to the weclome page and confirm success" do
          click_button submit
          current_path.should == welcome_path
          page.should have_an_alert.of_type(:success)
        end

      end

    end


  end
end
