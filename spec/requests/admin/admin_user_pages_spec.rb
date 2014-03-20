require 'spec_helper'

describe 'Admin users page' do

  subject { page }

  let(:title){ 'Users' }
  let(:tagline) { 'of My Web Brain'}
  let(:heading){ 'Users'}

  before do
    @number_of_users = [*3..10].sample
    FactoryGirl.create_list(:user, @number_of_users)
    visit admin_users_path
  end

  it_should_behave_like "all pages"

  it { should have_a(:users).table.with(@number_of_users).rows}

end

describe 'Admin user profile page' do 

  subject { page }

  let(:title) { 'User Profile ' }
  let(:heading) { 'User Profile for ' }

  let(:user) { FactoryGirl.create(:user)}

  before { visit admin_user_path(user) }

  it_should_behave_like "all pages"  

end
