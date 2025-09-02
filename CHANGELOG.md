# Changelog

## 2.0.0 / 2025-09-02

* Potentially Breaking Change: `img` tags with base64 encoded `src` values,
  which are not widely supported by markdown renderers, are removed to avoid
  parser performance issues and crashes

## 1.1.0 / 2024-04-19
* basic handling for nested lists

## 1.0.0 / 2018-03-27
* Delegate `ascii_tree` method to cause object
* Travis CI
* Upgrade deps
* Various cleanups

## v0.10.0 (17th June 2016)
* better handling of HTML entities
* better handling of hyperlinks with query strings

## v0.9.0 (8th November 2015)
* bump parslet dependency to 1.7.x
* converts some new HTML elements to markdown - h4, h5 and h6
* detects more content that looks like an unordered list and converts
  it to a markdown list
* strips some additional HTML tags and leaves the content, including
  * table
  * span
* strips some HTML elements
  * img tags with non http[s] src
* improved error when unbalanced HTML tags are detected

## v0.2.0 (21st July 2014)
* Upmark.convert() now raises an Upmark::ParseError exception if the supplied
  HTML can't be parsed
* Locked the parslet dependency to 1.4.0 for now
  * We depend on the Parslet:ParseError exception which was removed in parslet 1.5.0

## v0.1.4 (2nd August 2012)
* BUGFIX: handle single quotes in attribute values

## v0.1.3 (28th March 2012)
* BUGFIX: handle ampersands in attribute values

## v0.1.2 (26th September 2011)
* BUGFIX: handle newlines after a <br /> element

## v0.1.1 (26th September 2011)
* lots of refactoring

## v0.1.0 (25th September 2011)
* lots of refactoring

## v0.0.1 (23rd September 2011)
* initial release
