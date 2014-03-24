shared_examples_for "all pages" do

  let(:common_part_of_title) { 'My Web Brain' }

  it { should have_heading(heading)}
  it { should have_title(title)}

end

shared_examples_for "a signed in page" do

  it { should have_link('Sign out', href:signout_path) }
  it { should_not have_link('Sign in', href:signin_path) }
  it { should have_text(user.email).in(:navbar) }

end