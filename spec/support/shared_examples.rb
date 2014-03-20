shared_examples_for "all pages" do

  let(:common_part_of_title) { 'My Web Brain' }

  it { should have_heading(heading)}
  it { should have_title(title)}

end
