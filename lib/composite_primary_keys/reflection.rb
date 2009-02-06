module ActiveRecord
  module Reflection
    class AssociationReflection
      def initialize(macro, name, options, active_record)
        super
        if macro == :belongs_to && options[:foreign_key] && options[:foreign_key].is_a?(Array)
          active_record.class_eval do
            include CompositePrimaryKeys::ActiveRecord::AssociationPreload
          end
        end
      end
  
      def primary_key_name
        return @primary_key_name if @primary_key_name
        case
          when macro == :belongs_to
            @primary_key_name = options[:foreign_key] || class_name.foreign_key
          when options[:as]
            @primary_key_name = options[:foreign_key] || "#{options[:as]}_id"
          else
            @primary_key_name = options[:foreign_key] || active_record.name.foreign_key
        end
        @primary_key_name = @primary_key_name.to_composite_keys.to_s if @primary_key_name.is_a? Array
        @primary_key_name
      end
    end
  end
end
