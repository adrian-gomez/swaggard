module Swaggard
  module Swagger
    module Parameters
      class Base

        attr_reader :name, :description
        attr_writer :is_required

        def to_doc
          {
            'name'          => @name,
            'in'            => @in,
            'required'      => @is_required,
            'type'          => @data_type,
            'description'   => description
          }
        end

      end
    end
  end
end
