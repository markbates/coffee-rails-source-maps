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

          rel_path = if pathname.to_s.start_with?(Bundler.bundle_path.to_s)
            Pathname('bundler').join(pathname.relative_path_from(Bundler.bundle_path)).dirname
          else
            pathname.relative_path_from(Rails.root).dirname
          end

          map_dir = Rails.root.join("public/" + Rails.configuration.assets.prefix, "source_maps", rel_path)
          map_dir.mkpath

          map_file    = map_dir.join("#{clean_name}.map")
          coffee_file = map_dir.join("#{clean_name}.coffee")

          options[:sourceMap]   = true
          options[:filename]    = "#{clean_name}.coffee" # coffee requires filename option to work with source maps (see http://coffeescript.org/documentation/docs/coffee-script.html#section-4)
          options[:sourceFiles] = ["/#{coffee_file.relative_path_from(Rails.root.join("public"))}"] # specify coffee source file explicitly (see http://coffeescript.org/documentation/docs/sourcemap.html#section-8)

          wrapper = <<-WRAPPER
            (function(script, options) {
              try {
                return CoffeeScript.compile(script, options);
              } catch (err) {
                if (err instanceof SyntaxError && err.location) {
                  throw new SyntaxError([options.filename, err.location.first_line + 1, err.location.first_column + 1].join(":") + ": " + err.message)
                } else {
                  throw err;
                }
              }
            })
          WRAPPER

          ret = Source.context.call(wrapper, script, options)

          coffee_file.open('w') {|f| f.puts script }
          map_file.open('w')    {|f| f.puts ret["v3SourceMap"]}

          comment = "//@ sourceMappingURL=/#{map_file.relative_path_from(Rails.root.join("public"))}\n"
          return ret['js'] + comment
        end

      end

    end
  end

  # Monkeypatch this method to include the scripts' pathname
  require 'tilt/coffee'

  module Tilt
    class CoffeeScriptTemplate < Template
      def evaluate(scope, locals, &block)
        pathname = scope.respond_to?(:pathname) ? scope.pathname : nil
        @output ||= CoffeeScript.compile(data, options.merge(:pathname => pathname))
      end
    end
  end

end
