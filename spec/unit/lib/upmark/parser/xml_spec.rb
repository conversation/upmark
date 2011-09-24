require "spec_helper"

describe Upmark::Parser::XML do
  let(:parser) { Upmark::Parser::XML.new }

  context "#content" do
    subject { parser.content }

    it { should parse "" }
    it { should parse "messenger bag skateboard" }
    it { should parse "<p>messenger bag skateboard</p>" }
    it { should parse "messenger <p>bag</p> skateboard" }
    it { should parse "<p>messenger</p><p>bag</p><p>skateboard</p>" }
    it { should parse "<p>messenger</p>\n<p>bag</p>\n<p>skateboard</p>" }
    it { should parse "<p>messenger <strong>bag</strong> skateboard</p>" }
  end

  context "#element" do
    subject { parser.element }

    it { should     parse "<p></p>" }
    it { should     parse "<p>messenger bag skateboard</p>" }
    it { should     parse %q{<tofu art="party" />} }
    it { should_not parse "<p>" }
    it { should_not parse "<p>messenger bag skateboard" }
    it { should_not parse "messenger bag skateboard</p>" }
    it { should_not parse "<p>messenger bag skateboard<p>" }
  end

  context "#text" do
    subject { parser.text }

    it { should     parse "messenger bag skateboard" }
    it { should_not parse "<p>messenger bag skateboard</p>" }
    it { should_not parse "" }
  end

  context "#start_tag" do
    subject { parser.start_tag }

    it { should     parse %q{<tofu art="party">} }
    it { should     parse %q{<tofu art="party" synth="letterpress">} }
    it { should     parse "<tofu>" }
    it { should_not parse "</tofu>" }
    it { should_not parse "<tofu" }
    it { should_not parse "tofu>" }
  end

  context "#end_tag" do
    subject { parser.end_tag }

    it { should     parse "</tofu>" }
    it { should_not parse "<tofu>" }
    it { should_not parse "<tofu" }
    it { should_not parse "/tofu>" }
  end

  context "#empty_tag" do
    subject { parser.empty_tag }

    it { should     parse %q{<tofu />} }
    it { should     parse %q{<tofu art="party" />} }
    it { should     parse %q{<tofu art="party" synth="letterpress" />} }
    it { should_not parse "<tofu>" }
    it { should_not parse "</tofu>" }
    it { should_not parse "<tofu" }
    it { should_not parse "/tofu>" }
  end

  context "#name" do
    subject { parser.name }

    it { should     parse "p" }
    it { should     parse "h1" }
    it { should_not parse "1h" }
    it { should_not parse "h 1" }
  end

  context "#attribute" do
    subject { parser.attribute }

    it { should     parse %q{art="party organic"} }
    it { should     parse %q{art='party organic'} }
    it { should_not parse "art" }
    it { should_not parse "art=" }
    it { should_not parse "art=party" }
    it { should_not parse %q{="party organic"} }
    it { should_not parse %q{art="party organic'} }
    it { should_not parse %q{art='party organic"} }
  end

  context "#parse" do
    subject { parser.parse(html) }

    context "single tag" do
      let(:html) { "<p>messenger</p>" }

      it do
        should == [
          {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              content:   [{text: "messenger"}]
            }
          }
        ]
      end
    end

    context "empty tag" do
      let(:html) { "<br />" }

      it do
        should == [
          {
            element: {
              empty_tag: {name: "br", attributes: []}
            }
          }
        ]
      end
    end

    context "single tag with attributes" do
      let(:html) { %q{<a href="http://helvetica.com/" title="art party organic">messenger bag skateboard</a>} }

      it do
        should == [
          {
            element: {
              start_tag: {
                name: "a",
                attributes: [
                  {name: "href",  value: "http://helvetica.com/"},
                  {name: "title", value: "art party organic"}
                ]
              },
              end_tag: {name: "a"},
              content: [{text: "messenger bag skateboard"}]
            }
          }
        ]
      end
    end

    context "multiple inline tags" do
      let(:html) { "<p>messenger</p><p>bag</p><p>skateboard</p>" }

      it do
        should == [
          {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              content:   [{text: "messenger"}]
            }
          }, {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              content:   [{text: "bag"}]
            }
          }, {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              content:   [{text: "skateboard"}]
            }
          }
        ]
      end
    end

    context "multiple tags" do
      let(:html) { "<p>messenger</p>\n<p>bag</p>\n<p>skateboard</p>" }

      it do
        should == [
          {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              content:   [{text: "messenger"}]
            }
          }, {
            text: "\n"
          }, {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              content:   [{text: "bag"}]
            }
          }, {
            text: "\n"
          }, {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              content:   [{text: "skateboard"}]
            }
          }
        ]
      end
    end

    context "nested tags" do
      let(:html) { "<p>messenger <strong>bag</strong> skateboard</p>" }

      it do
        should == [
          {
            element: {
              start_tag: {name: "p", attributes: []},
              end_tag:   {name: "p"},
              content:   [
                {text: "messenger "},
                {
                  element: {
                    start_tag: {name: "strong", attributes: []},
                    content:   [{text: "bag"}],
                    end_tag:   {name: "strong"}
                  }
                }, {
                  text: " skateboard"
                }
              ]
            }
          }
        ]
      end
    end
  end
end
