module ActiverecordUml
  class Relation
    def initialize(left_name, multiplicity, right_name, association)
      @left_name = left_name
      @right_name = right_name
      @association = association
      @multiplicity = multiplicity
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
