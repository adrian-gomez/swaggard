require_relative 'operation'

module Swaggard
  module Swagger
    class Path
      attr_reader :path

      def initialize(path)
        @path = path
        @operations = {}
      end

      def add_operation(operation)
        @operations[operation.http_method.downcase] = operation
      end

      def ignore_put_if_patch!
        @operations.delete('put') if @operations.key?('patch')
      end

      def to_doc
        Hash[@operations.map { |http_method, operation| [http_method, operation.to_doc] }]
      end
    end
  end
end
