require "erb"

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
        "#{a.name.to_s.classify} --* #{@class_name}"
      end.concat(@class_name.reflect_on_all_associations(:has_many).map do |a|
        "#{@class_name} --* #{a.name.to_s.classify}"
      end).concat(@class_name.reflect_on_all_associations(:has_one).map do |a|
        "#{@class_name} --* #{a.name.to_s.classify}"
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
                                       .map { |a| a[1] }.join(", ")
        [m.to_s, method_parameters]
      end
    end
  end
end
