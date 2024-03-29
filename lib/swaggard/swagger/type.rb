module Swaggard
  module Swagger
    class Type
      BASIC_TYPES = {
        'integer'   => { 'type' => 'integer', 'format' => 'int32' },
        'long'      => { 'type' => 'integer', 'format' => 'int64' },
        'float'     => { 'type' => 'number',  'format' => 'float' },
        'double'    => { 'type' => 'number',  'format' => 'double' },
        'string'    => { 'type' => 'string' },
        'byte'      => { 'type' => 'string',  'format' => 'byte' },
        'binary'    => { 'type' => 'string',  'format' => 'binary' },
        'boolean'   => { 'type' => 'boolean' },
        'date'      => { 'type' => 'string',  'format' => 'date' },
        'date-time' => { 'type' => 'string',  'format' => 'date-time' },
        'datetime'  => { 'type' => 'string',  'format' => 'date-time' },
        'password'  => { 'type' => 'string',  'format' => 'password' },
        'hash'      => { 'type' => 'object' }
      }

      attr_reader :name

      def initialize(name, is_array = false)
        @name = name.to_s
        @is_array = is_array
      end

      def to_doc
        if @is_array
          { 'type' => 'array', 'items' => type_tag_and_name }
        else
          type_tag_and_name
        end
      end

      private

      def basic_type?
        BASIC_TYPES.has_key?(@name.downcase)
      end

      def custom_type?
        Swaggard.configuration.custom_types.has_key?(@name)
      end

      def type_tag_and_name
        if basic_type?
          BASIC_TYPES[@name.downcase].dup
        elsif custom_type?
          Swaggard.configuration.custom_types[@name].dup
        else
          { '$ref' => "#/definitions/#{name}" }
        end
      end
    end
  end
end
