# Upmark

A HTML to Markdown converter.

## Installation

    gem install upmark

## Usage

In ruby:

    require "upmark"
    html = %q{<p>messenger <strong>bag</strong> skateboard</p>}
    markdown = Upmark.convert(html)
    puts markdown

From the command-line:

    > upmark foo.html

You can also pipe poorly formatted HTML documents through `tidy` before piping them into `upmark`:

    > cat bar.html | tidy -asxhtml -indent -quiet --show-errors 0 --show-warnings 0 --show-body-only 1 --wrap 0 | upmark

## Features

Upmark will convert the following (arbitrarily nested) HTML elements to Markdown:

* `strong`
* `em`
* `p`
* `a`
* `h1`, `h2`, `h3`, `h4`, `h5`, `h6`
* `ul`
* `ol`
* `br`

It will also pass through block and span-level HTML elements (e.g. `table`, `div`, `span`, etc) which aren't used by Markdown.

## How it works

Upmark defines a parsing expression grammar (PEG) using the very awesome [Parslet](http://kschiess.github.com/parslet/) gem. This PEG is then used to convert HTML into Markdown in 4 steps:

1. Parse the XHTML into an abstract syntax tree (AST).
2. Normalize the AST into a nested hash of HTML elements.
3. Mark the block and span-level subtrees which should be ignored (`table`, `div`, `span`, etc).
4. Convert the AST leaves into Markdown.
