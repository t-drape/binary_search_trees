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

  def left_case(value, node)
    current_node = node.left_val
    # If no left node exists, we are at the end of the balanced BST, set left value equal to new node
    if current_node.nil?
      new_node = BstNode.new(value)
      node.left_val = new_node
    else
      insert(value, current_node)
    end
  end

  def right_case(value, node)
    current_node = node.right_val
    # If no right node exists, we are at the end of the balanced BST, set right value equal to new node
    if current_node.nil?
      new_node = BstNode.new(value)
      node.right_val = new_node
    else
      insert(value, current_node)
    end
  end

  def insert(value, node = @root)
    # Check if value in BST, return nil if present
    return nil if value == node.value

    # For value less than node value, use left half of array
    if value < node.value
      left_case(value, node)
    # For value greater than node value, use right half of array
    elsif value > node.value
      right_case(value, node)
    end
  end

  def delete(value, node = @root)
    puts value
  end

  def find(value, node = @root)
    return nil if node.nil?

    return node if value == node.value

    if value < node.value
      find(value, node.left_val)
    elsif value > node.value
      find(value, node.right_val)
    end
  end

  def level_order
    arr = []
    # Keep array as queue, FIFO: First In First Out
    queue = [@root]
    # Traverse the tree in breadth first order
    # Add Current Node
    until queue.empty?
      current_node = queue.shift
      # Add left child
      queue << current_node.left_val unless current_node.left_val.nil?
      # Add right child
      queue << current_node.right_val unless current_node.right_val.nil?
      if block_given?
        yield(current_node)
      else
        arr << current_node.value
      end
    end
    arr unless block_given?
  end

  def preorder
    # Preorder Traversal: Root node, Left node, Right node
    current_node = @root
    right_node = @root.right_val
    right_nodes = []
    values = []

    until current_node.nil? && right_nodes.empty?
      right_nodes << right_node unless right_node.nil?
      block_given? ? yield(current_node.val) : values << current_node.val
      current_node = current_node.left_val.nil? ? right_nodes.pop : current_node.left_val
      right_node = current_node.right_val unless current_node.nil?
    end
    values unless values.empty?
  end

  def inorder
    # Inorder Traversal: Left node, Root node, Right node

    current_node = @root
    roots = []
    values = []
    until current_node.right_val.nil? && roots.empty?
      until current_node.left_val.nil?
        # Each time, the value updates, keep old values in roots queue
        roots << current_node
        # Base case: go left
        current_node = current_node.left_val
      end
      # Now, the current node is the lowest value in BST
      # Add value to value array
      block_given? ? yield(current_node.val) : values << current_node.val
      if current_node.right_val.nil?
        current_node = roots.pop
        block_given? ? yield(current_node.val) : values << current_node.val
      end
      current_node = current_node.right_val
    end
    block_given? ? yield(current_node.val) : values << current_node.val
    values unless values.empty?
  end

  def postorder
    # Postorder Traversal: Left node, Right node, Root node
    # 3, 1, 7, 5, 4, 23, 9, 6345, 324, 67, 8

    current_node = @root
    values = []
    # Arr 1
    no_left_movement_nodes = []
    # Arr 2
    left_movement_allowed_nodes = []

    no_left_movement_nodes << current_node
    left_movement_allowed_nodes << current_node.right_val
    current_node = current_node.left_val

    # Step by Step
    # Var = root (8)
    until no_left_movement_nodes.empty? && left_movement_allowed_nodes.empty?
      no_left_movement_nodes << current_node
      left_movement_allowed_nodes << current_node.right_val unless current_node.right_val.nil?
      current_node = current_node.left_val
      next unless current_node.nil?

      current_node = left_movement_allowed_nodes.pop
      next unless current_node.left_val.nil? && current_node.right_val.nil?

      values << current_node.val
      current_node = no_left_movement_nodes.pop
      values << current_node.val
      current_node = left_movement_allowed_nodes.pop

      # next unless current_node.nil?

      # # Pop from arr 2
      # if left_movement_allowed_nodes.empty?
      #   no_left_movement_nodes.each do |e|
      #     values << e.val
      #   end
      # else
      #   current_node = left_movement_allowed_nodes.pop
      #   next unless current_node.right_val.nil? && current_node.left_val.nil?

      #   values << current_node.val
      #   current_node = no_left_movement_nodes.pop
      #   values << current_node.val
      #   current_node = left_movement_allowed_nodes.pop
      #   add_to = false
      # current_node = left_movement_allowed_nodes.pop
      # p current_node.val
      # values << current_node.val
      # next unless current_node.right_val.nil? && current_node.left_val.nil?

      # current_node = no_left_movement_nodes.pop
      # p current_node.val
      # values << current_node.val
      # current_node = current_node.right_val unless current_node.right_val.nil?
    end
    values
  end

  def height(comparable_node)
    height = 1
  end

  def depth(node)
    node_depth = 1
    compare_node = @root
    while node != compare_node
      node_depth += 1
      compare_node = node.value > compare_node.value ? compare_node.right_val : compare_node.left_val
      return nil if compare_node.nil?
    end
    node_depth
  end

  def pretty_print(node = @root, prefix = '', is_left_val = true)
    pretty_print(node.right_val, "#{prefix}#{is_left_val ? '│   ' : '    '}", false) if node.right_val
    puts "#{prefix}#{is_left_val ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left_val, "#{prefix}#{is_left_val ? '    ' : '│   '}", true) if node.left_val
  end
end

x = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

x.pretty_print

y = x.find(8)

p x.postorder
