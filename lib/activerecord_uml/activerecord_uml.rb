# frozen_string_literal: true
require "erb"
require_relative "diagram_drawer"

module ActiverecordUml
  class ActiverecordUml
    def initialize(args)
      @args = args
    end

    def draw
      puts html_template.result_with_hash class_diagrams: class_diagrams,
                                          relations: relations
    end

    private

    def class_diagrams
      options.include?(:relation_only) ? [] : classes.map { |c| c.class_diagram }
    end

    def relations
      classes.map { |c| c.relations }
             .flatten
             .select { |r| options.include?(:relation_only) ? r.belongs_to?(target_classes.map(&:name)) : true }
             .map(&:to_s)
             .uniq
    end

    def classes
      target_classes.map { |klass| DiagramDrawer.new(klass) }
    end

    def target_classes
      @args.select { |arg| !arg.start_with?("--") }
           .map { |model_name| Object.const_get model_name }
    end

    def options
      Set.new @args.select { |arg| arg.start_with?("--") }
                   .map { |arg| arg.gsub(/^--/, "").tr("-", "_").to_sym }
    end

    def html_template
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
