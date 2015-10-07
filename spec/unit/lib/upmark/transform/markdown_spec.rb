RSpec.describe Upmark::Transform::Markdown do
  let(:transform) { Upmark::Transform::Markdown.new }

  context "#apply" do
    subject { transform.apply(ast) }

    context "<p>" do
      context "single tag" do
        let(:ast) do
          [
            {
              element: {
                name: "p",
                attributes: [],
                children: [{text: "messenger bag skateboard"}],
                ignore: false
              }
            }
          ]
        end

        it { should == ["messenger bag skateboard\n\n"] }
      end

      context "multiple tags" do
        let(:ast) do
          [
            {
              element: {
                name: "p",
                attributes: [],
                children: [{text: "messenger"}],
                ignore: false
              }
            }, {
              element: {
                name: "p",
                attributes: [],
                children: [{text: "bag"}],
                ignore: false
              }
            }, {
              element: {
                name: "p",
                attributes: [],
                children: [{text: "skateboard"}],
                ignore: false
              }
            }
          ]
        end

        it { should == ["messenger\n\n", "bag\n\n", "skateboard\n\n"] }
      end
    end

    context "<a>" do
      context "single tag" do
        let(:ast) do
          [
            {
              element: {
                name: "a",
                attributes: [
                  {name: "href",  value: "http://helvetica.com/"},
                  {name: "title", value: "art party organic"}
                ],
                children: [{text: "messenger bag skateboard"}],
                ignore: false
              }
            }
          ]
        end

        it { should == [%q{[messenger bag skateboard](http://helvetica.com/ "art party organic")}] }
      end
    end

    context "<img>" do
      context "empty tag" do
        let(:ast) do
          [
            {
              element: {
                name: "img",
                attributes: [
                  {name: "src",   value: "http://helvetica.com/image.gif"},
                  {name: "title", value: "art party organic"},
                  {name: "alt",   value: "messenger bag skateboard"}
                ],
                children: [],
                ignore: false
              }
            }
          ]
        end

        it { should == [%q{![messenger bag skateboard](http://helvetica.com/image.gif "art party organic")}] }
      end
    end
  end
end
