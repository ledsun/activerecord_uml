# frozen_string_literal: true
require "erb"
require_relative "class_drawer"
require_relative "relation_drawer"

module ActiverecordUml
  class ActiverecordUml
    def initialize(args)
      @args = args
    end

    def draw
      puts html_template.result_with_hash classes: classes,
                                          relations: relations
    end

    private

    def classes
      options.include?(:relation_only) ? [] : target_classes.map { |klass| ClassDrawer.new(klass).class_diagram }
    end

    def relations
      target_classes.map { |c| RelationDrawer.new(c).relations }
        .flatten
        .select { |r| options.include?(:relation_only) ? r.belongs_to?(target_classes.map(&:name)) : true }
        .map(&:to_s)
        .uniq
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
<% classes.each do |d| %>
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
