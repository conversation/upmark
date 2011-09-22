require "spec_helper"

describe Upmark, ".convert" do
  subject { Upmark.convert(html) }

  let(:html) { <<-HTML.strip }
<p>messenger bag skateboard</p>

<p>messenger <em>bag</em> <strong>skateboard</strong></p>

<p><a href="http://helvetica.com/" title="art party organic">messenger <strong>bag</strong> skateboard</a></p>

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
messenger bag skateboard

messenger *bag* **skateboard**

[messenger **bag** skateboard](http://helvetica.com/ "art party organic")

* messenger
* **bag**
* skateboard

* messenger

* **bag**

* skateboard

1. messenger
2. **bag**
3. skateboard

1. messenger

2. **bag**

3. skateboard
  MD
end
