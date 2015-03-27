module Swaggard
  class Tag

    attr_accessor :name, :description

    attr_reader :controller_class

    def initialize(yard_object)
      @yard_name = yard_object.name
      @controller_class = "#{yard_object.namespace}::#{yard_object.name}".constantize

      @name =  '/'+ "#{@controller_class.controller_path}"
      @description = yard_object.docstring || ''
    end

    def to_doc
      {
        'name'        => @name,
        'description' => @description
      }
    end

    def valid?
      @yard_name.to_s.ends_with?('Controller') && @yard_name.to_s != 'ApplicationController'
    end

  end
end