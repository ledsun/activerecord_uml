module ActiverecordUml
  class Relation
    def initialize(left_name, multiplicity, right_name, association)
      @left_name = left_name
      @right_name = right_name
      @association = association
      @multiplicity = multiplicity
    end

    def belongs_to?(class_names)
      class_names.include?(@left_name.to_s) && class_names.include?(@right_name)
    end

    def to_s
      "#{@left_name} #{@multiplicity} #{@right_name}#{label}"
    end

    private

    def label
      @association.class_name != @association.name.to_s.classify ? " : #{@association.name.to_s.classify}" : ""
    end
  end
end
