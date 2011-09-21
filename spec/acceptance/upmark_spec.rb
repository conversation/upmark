require "spec_helper"

describe Upmark, ".convert" do
  subject { Upmark.convert(html) }

  context "text" do
    context "empty" do
      let(:html) { "" }
      it { should == "" }
    end

    context "single line" do
      let(:html) { "messenger bag skateboard" }
      it { should == "messenger bag skateboard" }
    end

    context "multiple lines" do
      let(:html) { "messenger bag skateboard\nart party salvia\nmustache artisan thundercats" }
      it { should == "messenger bag skateboard\nart party salvia\nmustache artisan thundercats" }
    end
  end

  context "<p>" do
    context "single element" do
      let(:html) { "<p>messenger bag skateboard\nart party salvia\nmustache artisan thundercats</p>" }
      it { should == "messenger bag skateboard\nart party salvia\nmustache artisan thundercats" }
    end

    context "multiple elements" do
      let(:html) { "<p>messenger bag skateboard</p>\n<p>art party salvia</p>\n<p>mustache artisan thundercats</p>" }
      it { should == "messenger bag skateboard\n\nart party salvia\n\nmustache artisan thundercats" }
    end

    context "multiple inline elements" do
      let(:html) { "<p>messenger bag skateboard</p><p>art party salvia</p><p>mustache artisan thundercats</p>" }
      it { should == "messenger bag skateboard\n\nart party salvia\n\nmustache artisan thundercats" }
    end
  end

  context "<strong>" do
    context "single element" do
      let(:html) { "<strong>messenger bag skateboard</strong>" }
      it { should == "**messenger bag skateboard**" }
    end

    context "nested elements" do
      let(:html) { "<p><strong>messenger</strong> bag skateboard</p>" }
      it { should == "**messenger** bag skateboard" }
    end
  end

  context "<em>" do
    context "single element" do
      let(:html) { "<em>messenger bag skateboard</em>" }
      it { should == "*messenger bag skateboard*" }
    end

    context "nested elements" do
      let(:html) { "<p><em>messenger</em> bag skateboard</p>" }
      it { should == "*messenger* bag skateboard" }
    end
  end

  context "<a>" do
    context "single element" do
      let(:html) { %q{<a href="http://helvetica.com/" title="art party organic">messenger bag skateboard</a>} }
      it { should == %q{[messenger bag skateboard](http://helvetica.com/ "art party organic")} }
    end
  end

  context "<ul>" do
    pending
  end

  context "<ol>" do
    pending
  end
end
