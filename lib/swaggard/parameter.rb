module Swaggard
  class Parameter
    attr_accessor :param_type, :name, :description, :data_type, :required, :allow_multiple, :allowable_values

    def initialize(yard_object)
      
    end
  end
end