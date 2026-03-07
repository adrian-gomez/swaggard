module Swaggard
  module Swagger
    module Parameters
      class Base

        attr_reader :name, :description
        attr_writer :is_required

        def to_doc
          doc = {
            'name'        => @name,
            'in'          => @in,
            'required'    => @is_required,
            'description' => description
          }
          doc['schema'] = { 'type' => @data_type } if @data_type
          doc
        end

      end
    end
  end
end
