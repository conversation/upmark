require "spec_helper"

describe Upmark::Parser do
  let(:parser) { Upmark::Parser.new }

  context "#element" do
    subject { parser.element }

    it { should     parse("<p>messenger bag skateboard</p>") }
    it { should_not parse("<p>messenger bag skateboard") }
    it { should_not parse("messenger bag skateboard</p>") }
    it { should_not parse("<p>messenger bag skateboard<p>") }
  end
  context "#text" do
    subject { parser.text }

    it { should     parse("messenger bag skateboard") }
    it { should_not parse("<p>messenger bag skateboard</p>") }
  end
end
