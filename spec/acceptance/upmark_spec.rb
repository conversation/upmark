describe Upmark, ".convert" do
  subject { Upmark.convert(html) }

  context "<a>" do
    let(:html) { <<-HTML.strip }
<p><a href="http://helvetica.com/" title="art party organic">messenger <strong>bag</strong> skateboard</a></p>
    HTML

    it { should == <<-MD.strip }
[messenger **bag** skateboard](http://helvetica.com/ "art party organic")
    MD
  end

  context "<a> hard" do
    let(:html) { <<-HTML.strip }
<p><a href="http://jobs.latrobe.edu.au/jobDetails.asp?sJobIDs=545808&amp;sKeywords=business">Manager, Business Solutions</a></p>
    HTML

    it { should == <<-MD.strip }
[Manager, Business Solutions](http://jobs.latrobe.edu.au/jobDetails.asp?sJobIDs=545808&amp;sKeywords=business "")
    MD
  end

  context "<img>" do
    let(:html) { <<-HTML.strip }
<img src="http://helvetica.com/image.gif" title="art party organic" alt="messenger bag skateboard" />

    HTML

    it { should == <<-MD.strip }
![messenger bag skateboard](http://helvetica.com/image.gif "art party organic")
    MD
  end

  context "<p>" do
    let(:html) { <<-HTML.strip }
<p>• Bullet 1</p>
<p>• Bullet 2</p>
<p>messenger <strong>bag</strong> skateboard</p>

<p>art party<br />
organic</p>

<p>• Bullet 3</p>
<p>• Bullet 4</p>
<p>Something else</p>
    HTML

    it { should == <<-MD.strip }
* Bullet 1
* Bullet 2

messenger **bag** skateboard

art party
organic

* Bullet 3
* Bullet 4

Something else
    MD
  end

  context "<ul>" do
    let(:html) { <<-HTML.strip }
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

    it { should == <<-MD.strip }
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

  context "<ol>" do
    let(:html) { <<-HTML.strip }
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

    it { should == <<-MD.strip }
1. messenger
2. **bag**
3. skateboard

1. messenger

2. **bag**

3. skateboard
    MD
  end

  context "<h1>, <h2>, <h3>, <h4>, <h5>, <h6>" do
    let(:html) { <<-HTML.strip }
<h1>messenger bag skateboard</h1>
<h2>messenger bag skateboard</h2>
<h3>messenger bag skateboard</h3>
<h4>messenger bag skateboard</h4>
<h5>messenger bag skateboard</h5>
<h6>messenger bag skateboard</h6>
    HTML

    it { should == <<-MD.strip }
# messenger bag skateboard
## messenger bag skateboard
### messenger bag skateboard
#### messenger bag skateboard
##### messenger bag skateboard
###### messenger bag skateboard
    MD
  end

  context "block-level elements" do
    context "<div>" do
      let(:html) { <<-HTML.strip }
<div>messenger <strong>bag</strong> skateboard</div>
<div id="tofu" class="art party">messenger <strong>bag</strong> skateboard</div>
      HTML

      it { should == html }
    end

    context "<table>" do
      let(:html) { <<-HTML.strip }
<table>
  <tr>
    <td>messenger</td>
  </tr>
  <tr>
    <td><strong>bag</strong></td>
  </tr>
  <tr>
    <td>skateboard</td>
  </tr>
</table>
      HTML

      it { should == html }
    end

    context "<pre>" do
      let(:html) { <<-HTML.strip }
<pre>
  <code>
    messenger bag skateboard
  </code>
</pre>
      HTML

      it { should == html }
    end
  end

  context "span-level elements" do
    context "<span>" do
      let(:html) { <<-HTML.strip }
<span>messenger <strong>bag</strong> skateboard</span>
      HTML

      it { should == <<-MD.strip }
<span>messenger **bag** skateboard</span>
      MD
    end
  end

  context "plain text" do
    let(:html) { "• Bullet 1\n• Bullet 2\n" }
    it 'converts plain bullet points to text' do
      expect(subject).to eq "* Bullet 1\n* Bullet 2"
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
end
