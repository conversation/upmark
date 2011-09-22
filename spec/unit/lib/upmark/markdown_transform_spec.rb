require "spec_helper"

describe Upmark::MarkdownTransform do
  let(:transform) { Upmark::MarkdownTransform.new }

  context "#apply" do
    subject { transform.apply(ast) }

    context "<p>" do
      context "single element" do
        let(:ast) do
          [
            {
              element: {
                start_tag: {name: "p", attributes: []},
                end_tag:   {name: "p"},
                content:   [{text: "messenger bag skateboard"}]
              }
            }
          ]
        end

        it { should == ["messenger bag skateboard\n\n"] }
      end

      context "multiple elements" do
        let(:ast) do
          [
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

        it { should == ["messenger\n\n", "bag\n\n", "skateboard\n\n"] }
      end
    end

    context "<a>" do
      context "single element" do
        let(:ast) do
          [
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

        it { should == [%q{[messenger bag skateboard](http://helvetica.com/ "art party organic")}] }
      end
    end
  end
end
