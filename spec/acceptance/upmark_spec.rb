RSpec.describe Upmark, ".convert" do
  RSpec::Matchers.define :convert_to do |expected|
    match do
      actual == expected
    end

    def actual
      @converted_actual ||= Upmark.convert(@actual)
    end

    diffable
  end

  context "<a>" do
    specify 'converts to []()' do
      expect(<<-HTML.strip
        <p><a href="http://helvetica.com/" title="art party organic">messenger <strong>bag</strong> skateboard</a></p>
      HTML
      ).to convert_to <<-MD.strip
        [messenger **bag** skateboard](http://helvetica.com/ "art party organic")
      MD
    end
  end

  context "<a> hard" do
    specify 'converts as []()' do
      expect(<<-HTML.strip
        <p><a href="http://jobs.latrobe.edu.au/jobDetails.asp?sJobIDs=545808&amp;sKeywords=business">Manager, Business Solutions</a></p>
      HTML
      ).to convert_to <<-MD.strip
[Manager, Business Solutions](http://jobs.latrobe.edu.au/jobDetails.asp?sJobIDs=545808&amp;sKeywords=business "")
      MD
    end
  end

  context "<img>" do
    specify 'converts as ![]()' do
      expect(<<-HTML.strip
        <img src="http://helvetica.com/image.gif" title="art party organic" alt="messenger bag skateboard" />
      HTML
      ).to convert_to <<-MD.strip
![messenger bag skateboard](http://helvetica.com/image.gif "art party organic")
      MD
    end
  end

  context "<p>" do
    specify 'converts as plaintext' do
      expect(<<-HTML.strip
<p>• Bullet 1</p>
<p>• Bullet 2</p>
<p>messenger <strong>bag</strong> skateboard</p>

<p>art party<br />
organic</p>

<p>• Bullet 3</p>
<p>• Bullet 4</p>
<p>• Bullet 5</p>
<p>• Bullet 6</p>
<p>• Bullet 7</p>
<p>Something else</p>
      HTML
      ).to convert_to <<-MD.strip
* Bullet 1
* Bullet 2

messenger **bag** skateboard

art party
organic

* Bullet 3
* Bullet 4
* Bullet 5
* Bullet 6
* Bullet 7

Something else
      MD
    end

    it 'converts paragraph utf-8 bullet points to a markdown list' do
      expect("<p>• Bullet 1</p><p>• Bullet 2</p>").to convert_to "* Bullet 1\n* Bullet 2"
    end
  end

  context "<ul>" do
    specify 'converts as list' do
      expect(<<-HTML.strip
<ul>
  <li>messenger</li>
  <li><strong>bag</strong></li>
  <li>skateboard</li>
</ul>

<ul>
  <li><p>messenger</p></li>
  <li><p><strong>bag</strong></p></li>
  <li><p>skateboard</p></li>
</ul>

<ul>
  <li>• Bullet 1</li>
  <li>• Bullet 2</li>
</ul>
      HTML
      ).to convert_to <<-MD.strip
* messenger
* **bag**
* skateboard

* messenger

* **bag**

* skateboard

* Bullet 1
* Bullet 2
      MD
    end
  end

  context "<ol>" do
    specify 'converts as numbered list' do
      expect(<<-HTML.strip
<ol>
  <li>messenger</li>
  <li><strong>bag</strong></li>
  <li>skateboard</li>
</ol>

<ol>
  <li><p>messenger</p></li>
  <li><p><strong>bag</strong></p></li>
  <li><p>skateboard</p></li>
</ol>
      HTML
      ).to convert_to <<-MD.strip
1. messenger
2. **bag**
3. skateboard

1. messenger

2. **bag**

3. skateboard
      MD
    end
  end

  context "<h1>, <h2>, <h3>, <h4>, <h5>, <h6>" do
    specify 'converts as #' do
      expect(<<-HTML.strip
<h1>messenger bag skateboard</h1>
<h2>messenger bag skateboard</h2>
<h3>messenger bag skateboard</h3>
<h4>messenger bag skateboard</h4>
<h5>messenger bag skateboard</h5>
<h6>messenger bag skateboard</h6>
      HTML
      ).to convert_to <<-MD.strip
# messenger bag skateboard
## messenger bag skateboard
### messenger bag skateboard
#### messenger bag skateboard
##### messenger bag skateboard
###### messenger bag skateboard
      MD
    end
  end

  context "block-level elements" do
    context "<div>" do
      let(:html) { <<-HTML.strip }
<div>messenger <strong>bag</strong> skateboard</div>
<div id="tofu" class="art party">messenger <strong>bag</strong> skateboard</div>
      HTML

      specify 'are left alone' do
        expect(html).to convert_to html
      end
    end

    context "<table>" do
      let(:html) { <<-HTML.strip }
<table>
  <tr>
    <td><p><strong>messenger</strong></p></td>
    <td><p>bag</p></td>
  </tr>
  <tr>
    <td><p>messenger</p></td>
    <td><p><strong>bag</strong></p></td>
  </tr>
  <tr>
    <td>skateboarding</td>
    <td><p>is cool with all the kids<br/>
      or something</p></td>
  </tr>
  <tr>
    <td><strong>Messenger bags</strong></td>
    <td>are in with the hipsters though.</td>
  </tr>
</table>
      HTML

      specify 'is converted to paragraphs' do
        expect(html).to convert_to <<-MD.strip
**messenger**

bag

messenger

**bag**

skateboarding
is cool with all the kids
or something

**Messenger bags**
are in with the hipsters though.
        MD
      end
    end

    context "<pre>" do
      let(:html) { <<-HTML.strip }
<pre>
  <code>
    messenger bag skateboard
  </code>
</pre>
      HTML

      specify 'are left alone' do
        expect(html).to convert_to html
      end
    end
  end

  context "<span> elements" do
    specify 'are stripped' do
      expect(<<-HTML.strip
<span>messenger <strong>bag</strong> skateboard</span>
      HTML
      ).to convert_to <<-MD.strip
messenger **bag** skateboard
      MD
    end
  end

  context "plain text" do
    it 'containing plain bullet points converts to markdown' do
      expect(
        "• Bullet 1\n• Bullet 2\n"
      ).to convert_to "* Bullet 1\n* Bullet 2"
    end
  end

  context "unbalanced elements" do
    let(:html) { "<span><span>foo</span>" }

    it "should raise an exception" do
      expect {
        Upmark.convert(html)
      }.to raise_error(Upmark::ParseFailed)
    end
  end

  context "unbalanced elements" do
    let(:html) { "<p>foo</b>" }

    it "should raise an exception" do
      expect {
        Upmark.convert(html)
      }.to raise_error(Upmark::ParseFailed)
    end
  end
end
