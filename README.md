# Upmark

A HTML to Markdown converter.

## Installation

    gem install upmark

## Usage

    require "upmark"

    html = %q{<p>messenger <strong>bag</strong> skateboard</p>}
    markdown = Upmark.convert(html)
    puts markdown

## License

Upmark is Copyright (c) 2011 The Conversation Media Group and distributed under the MIT license.
