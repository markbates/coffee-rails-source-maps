require "coffee-rails-source-maps/version"

# Based on https://gist.github.com/naan/5096056
# config/initializers/source_maps.rb

if Rails.env.development?
  module CoffeeScript

    class << self

      def compile(script, options = {})
        script = script.read if script.respond_to?(:read)

        if options.key?(:no_wrap) && !options.key?(:bare)
          options[:bare] = options[:no_wrap]
        else
          options[:bare] = false
        end

        # adding source maps option. (source maps option requires filename option.)
        options[:sourceMap] = true
        options[:filename]  = options[:pathname].basename.to_s

        ret = Source.context.call("CoffeeScript.compile", script, options)

        map_dir = Rails.root.join("public/source_maps")
        map_dir.mkpath

        basename    = options[:pathname].basename('.coffee')
        map_file    = map_dir.join("#{basename}.map")
        coffee_file = map_dir.join("#{basename}.coffee")

        coffee_file.open('w') {|f| f.puts script }
        map_file.open('w')    {|f| f.puts ret["v3SourceMap"]}

        comment = "//@ sourceMappingURL=/source_maps/#{map_file.basename}\n"
        return comment + ret["js"]

      end

    end
  end

  # Monkeypatch this method to include the scripts' pathname
  require 'tilt/template'

  module Tilt
    class CoffeeScriptTemplate < Template
      def evaluate(scope, locals, &block)
        @output ||= CoffeeScript.compile(data, options.merge(pathname: scope.pathname))
      end
    end
  end

end