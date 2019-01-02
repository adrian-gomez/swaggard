module Swaggard
  module Parsers
    class Routes

      def run(routes)
        return {} unless routes

        routes.inject({}) do |parsed_routes, route|
          path = route_path(route)

          unless Swaggard.configuration.excluded_paths.any? { |excluded_path| Regexp.new(excluded_path) =~ path }
            verb = route_verb(route)

            parsed_routes[path] ||= {}
            parsed_routes[path][verb] = {
              controller:   route_controller(route),
              action:       route_action(route),
              path_params:  route_path_params(route)
            }
          end

          parsed_routes
        end.sort.to_h
      end

      private

      def route_controller(route)
        route.requirements[:controller]
      end

      def route_action(route)
        route.requirements[:action]
      end

      def route_verb(route)
        verb = route.verb
        verb = route.verb.source unless verb.is_a?(String)

        verb.gsub(/[$^]/, '')
      end

      def route_path(route)
        path = route.path.spec.to_s

        path.gsub!('(.:format)', '')
        route.required_parts.each { |part| path.gsub!(":#{part}", "{#{part}}") }

        path
      end

      def route_path_params(route)
        route.required_parts
      end

    end
  end
end
