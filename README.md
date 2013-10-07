# CoffeeScript Rails Source Maps

Adds CoffeeScript source maps support, introduced in version [1.6.1](http://coffeescript.org/#changelog), to Rails. This code is based on a Gist by [naan](https://gist.github.com/naan/5096056).

## Installation

Add this line to your application's Gemfile:

    gem 'coffee-rails-source-maps'

And then execute:

    $ bundle
    $ rm -rf tmp/cache/assets

Removing `tmp/cache/assets` will cause the asset pipeline to recompile all your coffeescripts on the next page load. This will ensure all source maps are generated.

## Usage

This gem should really only be used in development mode.

```ruby
group :development do
  gem 'coffee-rails-source-maps'
end
```

This gem will create a folder called `assets/source_maps` in the Rails `public` directory. I would recommend adding this to your `.gitignore` file so you don't check this folder into git.

```
public/assets/source_maps/
```

### Using Source Maps in Chrome

In order to use the source maps you need to use a browser that supports them. Chrome is an excellent choice.

Open the Chrome console and click on the settings tab. You'll see an option to enable source maps, make sure that is checked.

![](http://i.imgur.com/5ndSqZV.jpg)

### Activating the Map

Finally to see your CoffeeScript code in the Chrome console just add a `debugger` call in your code and you'll see the CoffeeScript in your console to debug.

## Help! I'm Not Seeing Maps!

Make sure you've deleted `tmp/cache/assets`, restarted your server, enabled source maps in Chrome, and cleared its cache.

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
* Sean Santry
* Eric Boehs
* Tim Moore
* Sam Dornan
* Brent Dillingham
* Alexey Chernenkov
* Curtis Steckel
* Whitney Young
* Thomas Walpole
