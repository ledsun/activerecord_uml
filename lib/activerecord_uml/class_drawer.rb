require "erb"

module ActiverecordUml
  class ClassDrawer
    CLASS_TEMPLATE = <<EOF
class <%= klass.name %> {
<% klass.columns.each do |c| %>
  <%= sprintf("%8s %s", c.type, c.name) %>
<% end %>
<% methods.each do |m, parameters| %>
  <%= sprintf("%s(%s)", m, parameters) %>
<% end %>
}
EOF

    def initialize(klass)
      @klass = klass
    end

    def diagram
      class_template.result_with_hash klass: @klass, methods: methods
    end

    private

    def class_template
      ERB.new CLASS_TEMPLATE, nil, "<>"
    end

    def methods
      @klass.public_instance_methods(false).sort.map do |m|
        method_parameters = @klass.new.method(m)
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
