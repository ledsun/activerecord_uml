# frozen_string_literal: true
require "erb"
require_relative "activerecord_uml/version"
require_relative "activerecord_uml/diagram_drawer"

module ActiverecordUml
  class << self
    def draw(relation_only = false)
      target_classes = ARGV.select { |arg| !arg.start_with?("--") }
      options = Set.new ARGV.select { |arg| arg.start_with?("--") }.map { |arg| arg.gsub(/^--/, '')}

      if relation_only
        options << "relation_only"
      end

      classes = target_classes.map { |model_name| DiagramDrawer.new(model_name) }
      puts html_template.result_with_hash class_diagrams: options.include?("relation-only") ? [] : classes.map { |c| c.class_diagram },
                                          relations: classes.map { |c| c.relations }
                                                            .flatten
                                                            .select { |r| options.include?("relation-only") ? r.belongs_to?(target_classes) : true }
                                                            .map(&:to_s)
                                                            .uniq
    end

    private def html_template
      html = <<EOF
<html>
  <body>
    <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
    <script>mermaid.initialize({startOnLoad:true});</script>

    <div class="mermaid">

classDiagram
<% class_diagrams.each do |d| %>
  <%= d %>
<% end %>
<% relations.each do |r| %>
  <%= r %>
<% end %>

    </div>
  </body>
</html>
EOF

      ERB.new html, nil, "<>"
    end
  end
end
