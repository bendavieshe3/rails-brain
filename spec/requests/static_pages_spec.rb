require 'spec_helper'

describe "Static pages" do
  
  let(:common_part_of_title) { 'My Web Brain' }
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_heading(heading)}
    it { should have_title(title)}
  end

  describe "Home page" do
    before { visit root_path }

    let(:title) { 'My Web Brain: Your Brain on the Internet' }
    let(:heading) { 'My Web Brain' }

    it_should_behave_like "all static pages"
    it { should have_content('Your Brain on the Internet')}
    it { should_not have_title('Home')}

  end

  describe "Help page" do
    before { visit help_path }

    let(:title) { "Help | #{common_part_of_title}" }
    let(:heading) { "Help" }

    it_should_behave_like "all static pages"

  end

  describe "About page" do
    before { visit about_path }

    let(:title) { "About | #{common_part_of_title}" }
    let(:heading) { "About My Web Brain" }

    it_should_behave_like "all static pages"

  end

end
