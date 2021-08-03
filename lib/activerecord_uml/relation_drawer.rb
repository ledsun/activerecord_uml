require "erb"
require_relative "./relation.rb"

module ActiverecordUml
  class RelationDrawer
    def initialize(klass)
      @klass = klass
    end

    def relations
      @klass.reflect_on_all_associations(:belongs_to).map do |a|
        Relation.new(a.class_name, "--*", @klass, a)
      end.concat(@klass.reflect_on_all_associations(:has_many).map do |a|
        if a.is_a? ActiveRecord::Reflection::ThroughReflection
          if a.source_reflection
            # If a source association is specified, the class name of the source association is displayed.
            Relation.new(@klass, "*--*", a.source_reflection.class_name, a)
          else
            Relation.new(@klass, "*--*", a.class_name, a)
          end
        else
          Relation.new(@klass, "--*", a.class_name, a)
        end
      end).concat(@klass.reflect_on_all_associations(:has_one).map do |a|
        Relation.new(@klass, "--*", a.class_name, a)
      end)
    end
  end
end
