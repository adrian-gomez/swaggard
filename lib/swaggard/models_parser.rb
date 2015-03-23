require_relative 'model'
require_relative 'property'

module Swaggard
  class ModelsParser
    attr_reader :listing

    # def initialize
    #   @listing = ResourceListing.new
    # end

    def run(yard_objects)
      models = []

      model = nil
      yard_objects.each do |yard_object|
        if yard_object.type == :class
          p yard_object
          p yard_object.tags

          model = Model.new(yard_object)

          yard_object.tags.each do |tag|
            attribute = Property.new(tag)
            model.add_property(attribute)
          end
          models << model

        # elsif yard_object.type == :method
        #   # p yard_object
        #   # p yard_object.tags
        #
        #   attribute = Property.new(yard_object)
        #   model.add_property(attribute)
        end
      end

      # @listing.add(api_declaration)
      models
    end

  end
end