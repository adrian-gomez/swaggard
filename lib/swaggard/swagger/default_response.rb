module Swaggard
  module Swagger
    class DefaultResponse

      def status_code
        'default'
      end

      def to_doc
        {
          'description' => 'successful operation'
        }
      end

    end
  end
end