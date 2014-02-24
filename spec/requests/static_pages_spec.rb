require 'spec_helper'

describe "Static pages" do
  
  describe "Home page" do

    it "should have the content 'My Web Brain'" do
      visit '/static_pages/home'
      expect(page).to have_content('My Web Brain')
    end

    it "should have the tagline 'Your Brain on the Internet'" do
      visit '/static_pages/home'
      expect(page).to have_content('Your Brain on the Internet')
    end

    it "should have the full name of the site in the title" do
      visit '/static_pages/home'
      expect(page).to have_title("My Web Brain: Your Brain on the Internet")
    end

  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have it should have 'Help' as the title" do
      visit '/static_pages/help'
      expect(page).to have_title("Help | My Web Brain")
    end

  end

  describe "About page" do

    it "should have the content 'About My Web Brain'" do
      visit '/static_pages/about'
      expect(page).to have_content('About My Web Brain')
    end

    it "should have it should have 'About' as the title" do
      visit '/static_pages/about'
      expect(page).to have_title("About | My Web Brain")
    end

  end


end
