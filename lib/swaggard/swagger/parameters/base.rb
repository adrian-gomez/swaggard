module Swaggard
  module Swagger
    module Parameters
      class Base

        attr_reader :name
        attr_writer :is_required

        def to_doc
          {
            'name'          => @name,
            'in'            => @in,
            'description'   => @description,
            'required'      => @is_required,
            'type'          => @data_type
          }
        end

      end
    end
  end
end
