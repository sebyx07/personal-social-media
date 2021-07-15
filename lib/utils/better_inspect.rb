# frozen_string_literal: true

module BetterInspect
  class ObjectInspector
    class Error < StandardError; end
    attr_reader :object
    def initialize(object)
      @object = object
    end

    def call
      return default unless object.respond_to?(:inspected_values, true)
      call_nested
    end

    def call_nested
      inspected_values = object.send(:inspected_values)
      raise Error, "#inspected_values must return a hash for #{object.class.name}" unless inspected_values.is_a?(Hash)
      default + " (" + inspected_values.map do |field_name, value|
        InspectedValue.new(field_name, value)
      end.sort_by(&:is_user_object?).map do |inspected_value|
        inspected_value.to_s
      end.join(" ") + ")"
    rescue Exception => e
      print "\n#{e}"
      default
    end

    private
      def default
        "<#{object.class.name}:#{get_object_id}>".blue
      end

      def get_object_id
        object.try(:id) || object.object_id
      end
  end

  class InspectedValue
    NON_USER_OBJECT_CLASSES = [Hash, Array, Numeric, String]
    def initialize(name, value)
      @name = name
      @value = value
    end

    def to_s
      simple_render
    end

    def simple_render
      "#{@name.to_s.red}=#{@value.inspect.to_s.green}"
    end

    def is_user_object?
      NON_USER_OBJECT_CLASSES.each do |klass|
        return 0 if @value.is_a?(klass)
      end
      1
    end
  end

  def inspect
    ObjectInspector.new(self).call
  end
end
