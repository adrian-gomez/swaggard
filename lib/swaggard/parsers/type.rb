require_relative '../swagger/type'

module Swaggard
  module Parsers
    module Type
      def self.run(string)
        parts = string.split(/[<>]/)
        name = parts.last
        is_array = parts.grep(/array/i).any?

        Swaggard::Swagger::Type.new(name, is_array)
      end
    end
  end
end
