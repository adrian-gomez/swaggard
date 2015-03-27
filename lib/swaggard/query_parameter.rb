module Swaggard
  class QueryParameter

    PARAM_TYPE = 'query'

    attr_reader :name

    def initialize(string)
      parse(string)
    end

    def to_doc
      {
        'name'          => @name,
        'in'            => PARAM_TYPE,
        'description'   => @description,
        'required'      => @is_required,
        'type'          => @data_type
      }
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