# frozen_string_literal: true
require "erb"
require_relative "activerecord_uml/version"
require_relative "activerecord_uml/diagram_drawer"

module ActiverecordUml
  def self.draw(relation_only = false)
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

    html_template = ERB.new html, nil, "<>"
    classes = ARGV.map { |model_name| DiagramDrawer.new(model_name) }
    puts html_template.result_with_hash class_diagrams: relation_only ? [] : classes.map { |c| c.class_diagram },
                                        relations: classes.map { |c| c.relations }
                                                          .flatten
                                                          .select { |r| r.belongs_to?(ARGV) }
                                                          .map(&:to_s)
                                                          .uniq
  end
end
