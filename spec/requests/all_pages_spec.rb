require 'spec_helper'
require 'ostruct'

shared_examples_for "all pages" do

  let(:common_part_of_title) { 'My Web Brain' }

  it { should have_heading(heading)}
  it { should have_title(title)}

end

# TODO regularise this data into a class 
any_page = OpenStruct.new(top_menu:'#top-menu', site_title:'site-title')

describe "all pages" do

  describe "the layout" do

    before { visit root_path }

    let(:current_page) { any_page }

    it "should have the right links in the footer" do
      within_the('footer') { click_link "About" }
      current_path.should == about_path

      within_the('footer') { click_link "Home" }
      current_path.should == root_path

      within_the('footer') { click_link "Contact" }
      current_path.should == about_path

    end

    it "should have the right links in the header" do

      within_the(current_page.top_menu) { click_link "About" }
      current_path.should == about_path

      within_the(current_page.top_menu) { click_link "Help" }
      current_path.should == help_path

      within_the(current_page.top_menu) { click_link current_page.site_title }
      current_path.should == root_path

    end



  end
end