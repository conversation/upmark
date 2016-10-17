RSpec.describe Upmark::ParseFailed, ".ascii_tree" do
  it "delegates to a cause object" do
    cause = double(ascii_tree: double)
    error = Upmark::ParseFailed.new("oh noes", cause)
    expect(error.ascii_tree).to be(cause.ascii_tree)
  end

  it "returns nil when there is no cause" do
    error = Upmark::ParseFailed.new("oh noes", nil)
    expect(error.ascii_tree).to be_nil
  end
end
