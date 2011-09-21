require "spec_helper"

describe Upmark::Parser do
  let(:parser) { Upmark::Parser.new }

  context "#content" do
    subject { parser.content }

    it { should parse("") }
    it { should parse("messenger bag skateboard") }
    it { should parse("<p>messenger bag skateboard</p>") }
    it { should parse("messenger <p>bag</p> skateboard") }
    it { should parse("<p>messenger</p><p>bag</p><p>skateboard</p>") }
    it { should parse("<p>messenger <strong>bag</strong> skateboard</p>") }
  end

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
    it { should_not parse("") }
  end
end
