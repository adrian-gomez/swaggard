require_relative 'type'

module Swaggard
  class Property

    attr_reader :property_name, :type, :description

    def initialize(yard_object)
      @property_name = yard_object.name
      @type = Type.from_type_list(yard_object.types)
      @description = ''
    end

    def model_name
      @type.model_name
    end

    def to_h
      result = @type.to_h
      result["description"] = @description if @description
      result
    end

  end
end