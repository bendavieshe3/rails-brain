require 'spec_helper'

describe ApplicationHelper do

  describe "page_title" do

    context 'when embelishing with the base title' do   
      before { title('foo') }

      it "should include the provided title" do
        page_title.should match(/foo/)
      end

      it "should include the the base title" do 
        page_title.should match(Regexp.new(base_title))
      end
    end

    context 'when not embelishing with the base title' do
      before { title('bar', embelish_page_title:false)}

      it "should match the provided title exactly" do
        page_title.should == 'bar'
      end
    end

    context 'when no heading is provided' do

      it "should match the base title exactly" do
        page_title.should == base_title
      end

    end


  end


end
