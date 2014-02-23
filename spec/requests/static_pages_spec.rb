require 'spec_helper'

describe "Static pages" do
  
  describe "Home page" do

    it "should have the content 'My Web Brain'" do
      visit '/static_pages/home'
      expect(page).to have_content('My Web Brain')
    end

  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
  end

  describe "About page" do

    it "should have the content 'About My Web Brain'" do
      visit '/static_pages/about'
      expect(page).to have_content('About My Web Brain')
    end
  end

end
