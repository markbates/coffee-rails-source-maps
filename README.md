# CoffeeScript Rails Source Maps

Adds CoffeeScript source maps support, introduced in version [1.6.1](http://coffeescript.org/#changelog), to Rails. This code is based on a Gist by [naan](https://gist.github.com/naan/5096056).

## Installation

Add this line to your application's Gemfile:

    gem 'coffee-rails-source-maps'

And then execute:

    $ bundle

## Usage

This gem should really only be used in development mode.

```ruby
group :development do
  gem 'coffee-rails-source-maps'
end
```

This gem will create a folder called `source_maps` in the Rails `public` directory. I would recommend adding this to your `.gitignore` file so you don't check this folder into git.

```
public/source_maps/
```

### Using Source Maps in Chrome

In order to use the source maps you need to use a browser that supports them. Chrome is an excellent choice.

Open the Chrome console and click on the settings tab. You'll see an option to enable source maps, make sure that is checked.

![](http://i.imgur.com/5ndSqZV.jpg)

### Activating the Map

Finally to see your CoffeeScript code in the Chrome console just add a `debugger` call in your code and you'll see the CoffeeScript in your console to debug.

## Help! I'm Not Seeing Maps!

Ah, yes, I too have run into this. If you're using the asset-pipeline, and you probably are since this gem requires it. Then you need to touch your CoffeeScript files in order for the asset-pipeline to generate the map for that file. Once you do that the next time you access the file in Chrome a source map should be generated for you and you'll see it in the browser.

If you're still not seeing source maps trying adding:

```ruby
gem 'tilt'
```

in your `Gemfile` before the `coffee-rails-source-maps` gem. That has been proven to fix the issue.

Good luck!

## Acknowledgements

This gem is based on the following Gist: [https://gist.github.com/naan/5096056](https://gist.github.com/naan/5096056).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributers

* Mark Bates
* Raymond Vellener
* Thomas Walpole
