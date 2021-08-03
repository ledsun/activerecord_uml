require "erb"
require_relative "./relation.rb"

module ActiverecordUml
  class RelationDrawer
    def initialize(class_name)
      @class_name = class_name
    end

    def relations
      @class_name.reflect_on_all_associations(:belongs_to).map do |a|
        Relation.new(a.class_name, "--*", @class_name, a)
      end.concat(@class_name.reflect_on_all_associations(:has_many).map do |a|
        if a.is_a? ActiveRecord::Reflection::ThroughReflection
          if a.source_reflection
            # If a source association is specified, the class name of the source association is displayed.
            Relation.new(@class_name, "*--*", a.source_reflection.class_name, a)
          else
            Relation.new(@class_name, "*--*", a.class_name, a)
          end
        else
          Relation.new(@class_name, "--*", a.class_name, a)
        end
      end).concat(@class_name.reflect_on_all_associations(:has_one).map do |a|
        Relation.new(@class_name, "--*", a.class_name, a)
      end)
    end
  end
end
