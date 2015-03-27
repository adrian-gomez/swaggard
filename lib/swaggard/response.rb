module Swaggard
  class Response

    attr_reader :status_code

    def initialize(status_code, value)
      @status_code = status_code
      parse(value)
    end

    def to_doc
      {
        'schema' => response_model
      }
    end

    private

    def parse(value)
      @is_array_response = value =~ /Array/
      @response_class = if @is_array_response
                          value.match(/^Array<(.*)>$/)[1]
                        else
                          value
                        end
    end

    def response_model
      if @is_array_response
        {
          'type'           => 'array',
          'items'          => {
            '$ref'        => "#/definitions/#@response_class"
          }
        }
      else
        { '$ref' => "#/definitions/#@response_class" }
      end

    end

  end
end