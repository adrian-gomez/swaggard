require_relative '../swagger/property'

module Swaggard
  module Parsers
    module Property
      def self.run(yard_object)
        name = yard_object.name.dup
        options_and_description = yard_object.text&.dup || ''

        options_and_description.gsub!("\n", ' ')
        options, description = options_and_description.match(/\A(\[.*\])?(.*)\Z/).captures
        options = options ? options.gsub(/\[?\]?\s?/, '').split(',') : []
        description = description.strip
        required = name.gsub!(/^!/, '')
        type = Parsers::Type.run(yard_object.types.first)

        Swaggard::Swagger::Property.new(name, type, description, required.present?, options)
      end
    end
  end
end
