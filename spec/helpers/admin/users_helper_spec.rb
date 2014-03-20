require 'spec_helper'
require 'uri'

describe Admin::UsersHelper do
  
  describe "the gravatar_for_method" do

    let(:user) { FactoryGirl.create(:user)}

    it "exists" do
      helper.should respond_to(:gravatar_for)
    end
    it "accepts a user object and returns an image tag" do
      image_tag = helper.gravatar_for(user)
      expect { image_tag.to match URI::regexp}
    end


  end

end
