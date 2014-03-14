require 'spec_helper'

describe User do
  
  before { @user = User.new(email:'user@example.com',
    password:'foobar', password_confirmation:'foobar')}

  subject { @user }

  it { should respond_to(:email)}
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:authenticate)}

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

  describe "when password is not present" do
    before do
      @user = User.new(email: 'user@example.com', password: ' ',
                       password_confirmation: ' ')
    end
    it { should_not be_valid }
  end

  describe "when the password doesn't match the confirmation" do
    before { @user.password_confirmation = 'mismatch' }
    it { should_not be_valid }
  end

  describe "return valid of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email)}

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with an invalid password" do 
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end

    describe "with a password that is too short" do
      before { @user.password = @user.password_confirmation = 'a' * 5 }
      it { should_not be_valid }
    end
  end

end
