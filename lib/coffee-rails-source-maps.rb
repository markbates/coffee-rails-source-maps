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

        pathname = options[:pathname]
        clean_name = pathname.basename.to_s.split(".").first

        # adding source maps option. (source maps option requires filename option.)
        options[:sourceMap] = true
        options[:filename]  = "#{clean_name}.coffee"

        ret = Source.context.call("CoffeeScript.compile", script, options)
        rel_path=if pathname.to_s.start_with?(Bundler.bundle_path.to_s)
          Pathname('bundler').join(pathname.relative_path_from(Bundler.bundle_path)).dirname
        else
          pathname.relative_path_from(Rails.root.join("app", "assets", "javascripts")).dirname
        end
        map_dir = Rails.root.join("public", "source_maps", rel_path)
        map_dir.mkpath

        map_file    = map_dir.join("#{clean_name}.map")
        coffee_file = map_dir.join("#{clean_name}.coffee")

        coffee_file.open('w') {|f| f.puts script }
        map_file.open('w')    {|f| f.puts ret["v3SourceMap"]}

        comment = "//@ sourceMappingURL=/#{map_file.relative_path_from(Rails.root.join("public"))}\n"
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

__END__
11:06:13 web.1  | options: {:bare=>false, :pathname=>#<Pathname:/Users/markbates/Dropbox/development/vogon-next/app/assets/javascripts/controllers/authors/edit_controller.js.coffee.erb>, :sourceMap=>true, :filename=>"edit_controller.js.coffee.erb"}
11:06:13 web.1  | basename: #<Pathname:edit_controller.js.coffee.erb>
11:06:13 web.1  | map_file: #<Pathname:/Users/markbates/Dropbox/development/vogon-next/public/source_maps/edit_controller.js.coffee.erb.map>
11:06:13 web.1  | coffee_file: #<Pathname:/Users/markbates/Dropbox/development/vogon-next/public/source_maps/edit_controller.js.coffee.erb.coffee>
11:06:13 web.1  | comment: "//@ sourceMappingURL=/source_maps/edit_controller.js.coffee.erb.map\n"

11:06:13 web.1  | options: {:bare=>false, :pathname=>#<Pathname:/Users/markbates/Dropbox/development/vogon-next/app/assets/javascripts/application.js.coffee>, :sourceMap=>true, :filename=>"application.js.coffee"}
11:06:13 web.1  | basename: #<Pathname:application.js>
11:06:13 web.1  | map_file: #<Pathname:/Users/markbates/Dropbox/development/vogon-next/public/source_maps/application.js.map>
11:06:13 web.1  | coffee_file: #<Pathname:/Users/markbates/Dropbox/development/vogon-next/public/source_maps/application.js.coffee>
11:06:13 web.1  | comment: "//@ sourceMappingURL=/source_maps/application.js.map\n"