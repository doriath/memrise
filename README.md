# Memrise [![Build Status](http://travis-ci.org/doriath/memrise.png)](http://travis-ci.org/doriath/memrise)

Memrise (www.memrise.com) API wrapper.

## Installation

Add this line to your application's Gemfile:

    gem 'memrise'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install memrise

## Usage

Sample script (that is using aspell) to check the spelling of all words in given course.

    require 'memrise'
    require 'raspell'

    memrise = Memrise.new
    course = memrise.find_iset('technical-english-380-words')
    items = memrise.get_items_for(course.id)

    speller = Aspell.new('en_GB')
    items.each do |item|
      item.word.gsub(/[\w\']+/).each do |word|
        if not speller.check(word)
          p item
        end
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
