require "coffee-rails-source-maps/version"

# Based on https://gist.github.com/naan/5096056
# config/initializers/source_maps.rb

if Rails.env.development?
  require 'coffee-script' #make sure CoffeeScript is loaded before we overwrite it.
  module CoffeeScript

    class << self

      def compile(script, options = {})
        script = script.read if script.respond_to?(:read)

        if options.key?(:no_wrap) && !options.key?(:bare)
          options[:bare] = options[:no_wrap]
        else
          options[:bare] = false
        end

        pathname = options[:pathname]
        if pathname.nil?
          return Source.context.call("CoffeeScript.compile", script, options)
        else
          clean_name = pathname.basename.to_s.split(".").first
          # adding source maps option. (source maps option requires filename option.)
          options[:sourceMap] = true
          options[:filename]  = "#{clean_name}.coffee"

          ret = Source.context.call("CoffeeScript.compile", script, options)

          rel_path = if pathname.to_s.start_with?(Bundler.bundle_path.to_s)
            Pathname('bundler').join(pathname.relative_path_from(Bundler.bundle_path)).dirname
          else
            pathname.relative_path_from(Rails.root).dirname
          end

          map_dir = Rails.root.join("public/" + Rails.configuration.assets.prefix, "source_maps", rel_path)
          map_dir.mkpath

          map_file    = map_dir.join("#{clean_name}.map")
          coffee_file = map_dir.join("#{clean_name}.coffee")

          coffee_file.open('w') {|f| f.puts script }
          map_file.open('w')    {|f| f.puts ret["v3SourceMap"]}

          comment = "//@ sourceMappingURL=/#{map_file.relative_path_from(Rails.root.join("public"))}\n"
          return comment + ret['js']
        end

      end

    end
  end

  # Monkeypatch this method to include the scripts' pathname
  require 'tilt/coffee'

  module Tilt
    class CoffeeScriptTemplate < Template
      def evaluate(scope, locals, &block)
        @output ||= CoffeeScript.compile(data, options.merge(:pathname => scope.pathname))
      end
    end
  end

end
