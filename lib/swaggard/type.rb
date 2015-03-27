module Swaggard
  class Type

    attr_reader :name

    def self.new(types)
      type = super

      all[type.name] = type

      type
    end

    def self.all
      @all ||= {}
    end

    def initialize(types)
      parse(types)
    end

    def to_doc
      doc = { type_tag => type }

      doc.merge!({ 'items' => { type_tag => name } }) if @is_array

      doc
    end

    private

    def parse(types)
      parts = types.first.split(/[<>]/)

      @name = parts.last
      @is_array = parts.grep(/array/i).any?
    end

    # TODO: have this look at resource listing?
    def ref?
      self.class.all[@name].present?
    end

    def model_name
      ref? ? @name : nil
    end

    def type
      @is_array ? 'array' : @name
    end

    def type_tag
      if !@is_array && ref?
        '$ref'
      else
        'type'
      end
    end

  end
end