module Swaggard
  class RoutesParser

    def run(routes)
      return {} unless routes

      parsed_routes = {}

      routes.each do |route|
        controller = route_controller(route)
        action = route_action(route)

        parsed_routes[controller] ||= {}
        parsed_routes[controller][action] = {
          verb:         route_verb(route),
          path:         route_path(route),
          path_params:  route_path_params(route)
        }
      end

      parsed_routes
    end

    private

    def route_controller(route)
      route.requirements[:controller]
    end

    def route_action(route)
      route.requirements[:action]
    end

    def route_verb(route)
      route.verb.source.gsub(/[$^]/, '')
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