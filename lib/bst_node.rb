# frozen_string_literal: true

# From TOP Binary Search Tree Project

# A class to model a node in the Binary Search Tree data structure
class BstNode
  attr_accessor :val, :left_val, :right_val

  def initialize(val, left_val = nil, right_val = nil)
    @val = val
    @left_val = left_val
    @right_val = right_val
  end
end
