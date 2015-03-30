module Swaggard
  module Swagger
    class Type

      attr_reader :name

      def self.new(types)
        type = super

        all[type.name] = type

        type
      end

      def self.all
        @all ||= {}
      end

      def initialize(types)
        parse(types)
      end

      def to_doc
        doc = if @is_array
                { 'type' => 'array' }
              else
                { type_tag => type_name }
              end


        doc.merge!({ 'items' => { type_tag => type_name } }) if @is_array

        doc
      end

      private

      def parse(types)
        parts = types.first.split(/[<>]/)

        @name = parts.last
        @is_array = parts.grep(/array/i).any?
      end

      # TODO: have this look at resource listing?
      def ref?
        self.class.all[@name].present?
      end

      def model_name
        ref? ? @name : nil
      end

      def type_tag
        if ref?
          '$ref'
        else
          'type'
        end
      end

      def type_name
        if ref?
          "#/definitions/#{name}"
        else
          name
        end
      end

    end
  end
end