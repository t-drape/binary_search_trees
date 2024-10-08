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
    return nil if value == node.val

    # For value less than node value, use left half of array
    if value < node.val
      left_case(value, node)
    # For value greater than node value, use right half of array
    elsif value > node.val
      right_case(value, node)
    end
  end

  def leaf_node_deletion(node, parent_node)
    if node.val < parent_node.val
      parent_node.left_val = nil
    else
      parent_node.right_val = nil
    end
  end

  def both_child_deletion(node)
    deletion_node = node
    # Lowest child in the right subtree
    node = node.right_val
    if node.left_val.nil?
      deletion_node.val = node.val
      deletion_node.right_val = node.right_val
    else
      until node.left_val.nil?
        lowest_parent_node = node
        node = node.left_val
      end
      deletion_node.val = node.val
      lowest_parent_node.left_val = node.right_val
    end
  end

  def one_child_deletion(node, parent_node)
    if node.val < parent_node.val
      # If less than parent node, set left child of parent equal to left child of delete node
      parent_node.left_val = node.left_val.nil? ? node.right_val : node.left_val
    else
      # If greater than parent node, set right child of parent equal to right child of delete node
      parent_node.right_val = node.right_val.nil? ? node.left_val : node.right_val
    end
  end

  def to_value_node(value)
    node = @root
    until node.val == value
      parent_node = node
      node = value < node.val ? node.left_val : node.right_val
      return nil if node.nil?
    end
    [node, parent_node]
  end

  def delete(value)
    node, parent_node = to_value_node(value)
    # Leaf node deletion
    # Left child nil and right child nil
    if node.left_val.nil? && node.right_val.nil?
      leaf_node_deletion(node, parent_node)
    # Left child not nil, Right child not nil
    elsif !node.left_val.nil? && !node.right_val.nil?
      both_child_deletion(node)
    # One child case
    else
      one_child_deletion(node, parent_node)
    end
  end

  def find(value, node = @root)
    return nil if node.nil?

    return node if value == node.val

    if value < node.val
      find(value, node.left_val)
    elsif value > node.val
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
        arr << current_node.val
      end
    end
    arr unless block_given?
  end

  def preorder(node = @root, values = [], &block)
    # Preorder Traversal: Root node, Left node, Right node
    return nil if node.nil?

    block_given? ? yield(node.val) : values << node.val
    preorder(node.left_val, values, &block)
    preorder(node.right_val, values, &block)
    block_given? ? nil : values
  end

  def inorder(node = @root, values = [], &block)
    # Inorder Traversal: Left node, Root node, Right node
    return nil if node.nil?

    inorder(node.left_val, values, &block)
    block_given? ? yield(node.val) : values << node.val
    inorder(node.right_val, values, &block)
    block_given? ? nil : values
  end

  def postorder(node = @root, values = [], &block)
    # Postorder Traversal: Left node, Right node, Root node
    # 3, 1, 7, 5, 4, 23, 9, 6345, 324, 67, 8
    return nil if node.nil?

    postorder(node.left_val, values, &block)
    postorder(node.right_val, values, &block)
    block_given? ? yield(node.val) : values << node.val
    block_given? ? nil : values
  end

  def height(node, height_total = 0)
    return height_total if node.left_val.nil? && node.right_val.nil?

    height_left = node.left_val.nil? ? 0 : height(node.left_val, height_total + 1)
    height_right = node.right_val.nil? ? 0 : height(node.right_val, height_total + 1)

    height_left > height_right ? height_left : height_right
  end

  def depth(node)
    return nil if node.nil?

    node_depth = 0
    compare_node = @root
    while node != compare_node
      node_depth += 1
      compare_node = node.val > compare_node.val ? compare_node.right_val : compare_node.left_val
      return nil if compare_node.nil?
    end
    node_depth
  end

  def balanced?
    # The left subtree of every node AND the right subtree of every node
    # return nil if node.nil?
    # block_given? ? yield(node.val) : values << node.val
    # preorder(node.left_val, values, &block)
    # preorder(node.right_val, values, &block)
    # block_given? ? nil : values
    node = @root
    right_nodes = []
    until node.nil? && right_nodes.empty?
      node = right_nodes.pop if node.nil?
      right_nodes << node.right_val unless node.right_val.nil?
      left_height = node.left_val.nil? ? 0 : height(node.left_val)
      right_height = node.right_val.nil? ? 0 : height(node.right_val)
      return false if (left_height - right_height).abs > 1

      node = node.left_val
    end
    true
  end

  def rebalance
    array = []
    inorder { |e| array << e }
    @root = build_tree(array)
  end

  # To get a stylistic format of the binary search tree, uncomment the next function! Provided by TOP :)
  # def pretty_print(node = @root, prefix = '', is_left_val = true)
  #   pretty_print(node.right_val, "#{prefix}#{is_left_val ? '│   ' : '    '}", false) if node.right_val
  #   puts "#{prefix}#{is_left_val ? '└── ' : '┌── '}#{node.val}"
  #   pretty_print(node.left_val, "#{prefix}#{is_left_val ? '    ' : '│   '}", true) if node.left_val
  # end
end
