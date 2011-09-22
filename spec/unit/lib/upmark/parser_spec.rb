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
    it { should parse("<p>messenger</p>\n<p>bag</p>\n<p>skateboard</p>") }
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

  context "#start_tag" do
    subject { parser.start_tag }

    it { should     parse %q{<tofu art="party">} }
    it { should     parse("<tofu>") }
    it { should_not parse("</tofu>") }
  end

  context "#end_tag" do
    subject { parser.end_tag }

    it { should     parse("</tofu>") }
    it { should_not parse("<tofu>") }
  end

  context "#attribute" do
    subject { parser.attribute }

    it { should     parse %q{art="party"} }
    it { should     parse %q{art='party'} }
    it { should_not parse("art") }
    it { should_not parse("=party") }
  end

  context "#parse" do
    subject { parser.parse(html) }

    context "single element" do
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

    context "single element with attributes" do
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

    context "multiple inline elements" do
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

    context "multiple elements" do
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

    context "nested elements" do
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
