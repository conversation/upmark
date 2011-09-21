require "spec_helper"

describe Upmark, ".convert" do
  subject { Upmark.convert(html) }

  context "text" do
    context "empty" do
      let(:html) { "" }
      it { should == "" }
    end

    context "one line" do
      let(:html) { "messenger bag skateboard" }
      it { should == "messenger bag skateboard" }
    end

    context "multi line" do
      let(:html) { "messenger bag skateboard\nart party salvia\nmustache artisan thundercats" }
      it { should == "messenger bag skateboard\nart party salvia\nmustache artisan thundercats" }
    end
  end

  context "<p>" do
    context "single" do
      let(:html) { "<p>messenger bag skateboard\nart party salvia\nmustache artisan thundercats</p>" }
      it { should == "messenger bag skateboard\nart party salvia\nmustache artisan thundercats\n\n" }
    end

    context "multiple" do
      let(:html) { "<p>messenger bag skateboard</p>\n<p>art party salvia</p>\n<p>mustache artisan thundercats</p>" }
      it { should == "messenger bag skateboard\n\nart party salvia\n\nmustache artisan thundercats\n\n" }
    end

    context "multiple inline" do
      let(:html) { "<p>messenger bag skateboard</p><p>art party salvia</p><p>mustache artisan thundercats</p>" }
      it { should == "messenger bag skateboard\n\nart party salvia\n\nmustache artisan thundercats\n\n" }
    end
  end

  context "<strong>" do
    context "single" do
      let(:html) { "<strong>messenger bag skateboard</strong>" }
      it { should == "**messenger bag skateboard**" }
    end

    context "nested" do
      let(:html) { "<p><strong>messenger</strong> bag skateboard</p>" }
      it { should == "**messenger** bag skateboard\n\n" }
    end
  end
end
