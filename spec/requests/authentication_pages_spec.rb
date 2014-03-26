require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do

    let(:title) { "Sign in" }
    let(:heading) { "Sign in" }

    before { visit signin_path }

    it_should_behave_like "all pages"

    it "should have an input field selected", js: true do
      input("Email").should have_the_focus
    end

    describe 'signin process', focus:true do

      describe "with invalid information" do
        before { click_button "Sign in" }

        it "should return the user to the page and show an error" do
          current_path.should == signin_path
          page.should have_an_alert.of_type(:error)
        end

        describe "after visting another page" do
          before { click_link "Home" }
          it { should_not have_an_alert.of_type(:error) }
        end

      end

      describe "with valid information" do

        let(:user) { FactoryGirl.create(:user) }

        before do
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        it "should navigate the user to the today page" do
          current_path.should == today_path
        end

        it_should_behave_like "a signed in page"

      end

    end

  end
end
