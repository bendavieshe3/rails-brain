require 'spec_helper'
# require_relative 'all_pages_spec'

describe "User Pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    let(:title) { "Sign up | #{common_part_of_title}" }
    let(:heading) { "Sign up" }

    it_should_behave_like "all pages"

  end
end
