require 'spec_helper'

describe User do
  
  before { @user = User.new(email:'user@example.com')}

  subject { @user }

  it { should respond_to(:email)}
  it { should be_valid }

  describe 'it should not be valid when email not present' do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end

  describe 'it should not be valid when email is too long' do
    before { @user.email = ('a' * 100) + '@example.com' }
    it { should_not be_valid }
  end

  describe 'it should only accept valid email formats' do

    it 'should be invalid when invalid email formats are provided' do
      addresses = %w{user@foo,com user_at_foo.org example.user@foo. 
                  foo@bar_baz.com foo@bar+baz.com }
      addresses.each do | address |
        @user.email = address
        @user.should_not be_valid
      end
    end

    it 'should be valid when valid email values are provided' do
      addresses = %w{user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn }
      addresses.each do | address |
        @user.email = address
        @user.should be_valid, "'#{address}' is not accepted as valid"
      end
    end

  end

  describe "should not be valid if the email address is taken" do
    before do
      user_with_the_same_email = @user.dup
      user_with_the_same_email.email = @user.email.upcase
      user_with_the_same_email.save
    end

    it { should_not be_valid }
  end



end
