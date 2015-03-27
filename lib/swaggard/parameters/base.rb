module Swaggard
  module Parameters
    class Base

      attr_reader :name

      def to_doc
        {
          'in'            => @in,
          'name'          => @name,
          'description'   => @description,
          'required'      => @is_required,
          'type'          => @data_type
        }
      end

    end
  end
end