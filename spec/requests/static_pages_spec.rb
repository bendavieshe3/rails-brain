require 'spec_helper'

describe "Static pages" do
  
  let(:common_part_of_title) { 'My Web Brain' }
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('My Web Brain')}
    it { should have_content('Your Brain on the Internet')}
    it { should have_title("My Web Brain: Your Brain on the Internet")}
    it { should_not have_title('Home')}

  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help')}
    it { have_title("Help | #{common_part_of_title}")}

  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About My Web Brain')}
    it { should have_title("About | #{common_part_of_title}")}
  end

end
