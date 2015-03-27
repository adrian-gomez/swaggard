require_relative 'base'

module Swaggard
  module Parameters
    class Form < Base

      def initialize(string)
        @in = 'formData'
        parse(string)
      end

      private

      # Example: [Array]     status            Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
      # Example: [Array]     status(required)  Filter by status. (e.g. status[]=1&status[]=2&status[]=3)
      # Example: [Integer]   media[media_type_id]                          ID of the desired media type.
      def parse(string)
        data_type, name, required, description = string.match(/\A\[(\w*)\]\s*([\w\[\]]*)(\(required\))?\s*(.*)\Z/).captures
        allow_multiple = name.gsub!('[]', '')

        @name = name
        @description = description
        @data_type = data_type.downcase
        @is_required = required.present?
        @allow_multiple = allow_multiple.present?
      end

    end
  end
end