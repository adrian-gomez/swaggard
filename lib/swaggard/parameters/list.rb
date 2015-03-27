require_relative 'base'

module Swaggard
  module Parameters
    class List < Base

      def initialize(string)
        @in = 'query'
        parse(string)
      end

      def to_doc
        doc = super

        doc.merge(
          {
            'type'            => 'array',
            'items'           => { 'type' => @data_type },
            'enum'            => @list_values
          }
        )
      end

      private

      # Example: [String]    sort_order  Orders ownerships by fields. (e.g. sort_order=created_at)
      #          [List]      id
      #          [List]      begin_at
      #          [List]      end_at
      #          [List]      created_at
      def parse(string)
        data_type, name, required, description, set_string = string.match(/\A\[(\w*)\]\s*(\w*)(\(required\))?\s*(.*)\n([.\s\S]*)\Z/).captures

        @list_values = set_string.split('[List]').map(&:strip).reject { |string| string.empty? }

        @name = name
        @description = description
        @data_type = data_type.downcase
        @is_required = required.present?
      end

    end
  end
end