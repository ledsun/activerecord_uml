# frozen_string_literal: true
require "erb"
require_relative "activerecord_uml/version"
require_relative "activerecord_uml/activerecord_uml"

module ActiverecordUml
  def self.draw
    ActiverecordUml.new(ARGV).draw
  end
end
