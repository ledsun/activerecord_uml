require "erb"
require_relative "./relation_drawer"

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

    def initialize(class_name)
      @class_name = class_name
    end

    def class_diagram
      class_template.result_with_hash class_name: @class_name, methods: methods
    end

    def relations
      RelationDrawer.new(@class_name).relations
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
  end
end
