require "erb"
require_relative "./relation.rb"

module ActiverecordUml
  class DiagramDrawer
    CLASS_TEMPLATE = <<EOF
class <%= class_name %> {
<% class_name.columns.each do |c| %>
  <%= sprintf("%8s %s", c.type, c.name) %>
<% end %>
<% methods.each do |m, parameters| %>
  <%= sprintf("%s(%s)", m, parameters) %>
<% end %>
}
EOF

    def initialize(model_name)
      begin
        @class_name = Object.const_get model_name
      rescue NameError
        STDERR.puts "#{model_name}というクラスがみつかりません"
        raise
      end
    end

    def class_diagram
      class_template.result_with_hash class_name: @class_name, methods: methods
    end

    def relations
      @class_name.reflect_on_all_associations(:belongs_to).map do |a|
        Relation.new(a.class_name, "--*", @class_name, a).to_s
      end.concat(@class_name.reflect_on_all_associations(:has_many).map do |a|
        if a.is_a? ActiveRecord::Reflection::ThroughReflection
          if a.source_reflection
            # If a source association is specified, the class name of the source association is displayed.
            Relation.new(@class_name, '*--*', a.source_reflection.class_name, a).to_s
          else
            Relation.new(@class_name, '*--*', a.class_name, a).to_s
          end
        else
          Relation.new(@class_name, '--*', a.class_name, a).to_s
        end
      end).concat(@class_name.reflect_on_all_associations(:has_one).map do |a|
        Relation.new(@class_name, '--*', a.class_name, a).to_s
      end)
    end

    private

    def class_template
      ERB.new CLASS_TEMPLATE, nil, "<>"
    end

    def methods
      @class_name.public_instance_methods(false).sort.map do |m|
        method_parameters = @class_name.new.method(m)
                                       .parameters
                                       .filter { |a| a[0] == :req }
                                       .map { |a| a[1] }

        if method_parameters.length > 3
          method_parameters = method_parameters.slice(0, 3).append("...")
        end

        [m.to_s, method_parameters.join(", ")]
      end
    end

    def label_for(association)
      association.class_name != association.name.to_s.classify ? " : #{association.name.to_s.classify}" : ""
    end
  end
end
