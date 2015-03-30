require_relative 'base'

module Swaggard
  module Swagger
    module Parameters
      class Path < Base

        attr_reader :name

        def initialize(param_name)
          @in = 'path'
          @name = param_name.to_s
          @data_type = 'string'
          @is_required = true
          @description = "Scope response to #{@name}"
        end

      end
    end
  end
end