require_relative 'base'

module Swaggard
  module Swagger
    module Parameters
      class Path < Base

        attr_reader :operation, :name

        def initialize(operation, param_name)
          @operation = operation
          @in = 'path'
          @name = param_name.to_s
          @data_type = 'string'
          @is_required = true
        end

        def description
          @description ||= get_description
        end

        private

        def get_description
          if Swaggard.configuration.path_parameter_description.respond_to?(:call)
            Swaggard.configuration.path_parameter_description.call(self)
          else
            Swaggard.configuration.path_parameter_description
          end
        end
      end
    end
  end
end
