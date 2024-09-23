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
    block_given? ? nil : values
  end

  def inorder(node)
    # Inorder Traversal: Left node, Root node, Right node

    current_node = @root
    right_node = @root.right_val
    right_nodes = []
    roots = []
    values = []

    until current_node.nil? && roots.empty?
      roots << current_node
      p current_node.val
      current_node = current_node.left_val.nil? ? roots.pop : current_node.left_val
    end
    p roots
    block_given? ? nil : values

    # return nil if node.nil?

    # inorder(node.left_val)
    # puts node.val
    # inorder(node.right_val)
  end

  def postorder(node)
    # Postorder Traversal: Left node, Right node, Root node
    return nil if node.nil?

    postorder(node.left_val)
    postorder(node.right_val)
    puts node.val
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

x.inorder(y)
