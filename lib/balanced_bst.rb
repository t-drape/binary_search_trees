# frozen_string_literal: true

require_relative('bst_node')

# A model to implement the Balanced Binary Search Tree data structure
class Tree
  def initialize(arr)
    @array = arr
    @root = build_tree(@array)
  end

  def build_tree(arr)
    # Sort the array and Remove duplicates
    sorted_unique_array = arr.uniq.sort
    p sorted_unique_array

    n = sorted_unique_array.length - 1
    sorted_arr_to_bst(sorted_unique_array, 0, n)
  end

  def sorted_arr_to_bst(arr, start_val, end_val)
    # Base Case
    return nil if start_val > end_val

    # Find the middle value
    middle_val = (start_val + end_val) / 2
    # Create a new node
    root = BstNode.new(arr[middle_val])
    # Set its left value
    root.left_val = sorted_arr_to_bst(arr, start_val, middle_val - 1)
    # Set its right value
    root.right_val = sorted_arr_to_bst(arr, middle_val + 1, end_val)
    # Return the root node
    root
  end

  def pretty_print(node = @root, prefix = '', is_left_val = true)
    pretty_print(node.right_val, "#{prefix}#{is_left_val ? '│   ' : '    '}", false) if node.right_val
    puts "#{prefix}#{is_left_val ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_val, "#{prefix}#{is_left_val ? '    ' : '│   '}", true) if node.left_val
  end
end

x = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

x.pretty_print
