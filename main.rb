# frozen_string_literal: true

# Driver script for TOP Binary Search Trees Project

# Require Tree Class
require_relative('lib/balanced_bst')

# Create a binary search tree from an array of random numbers
# (Array.new(15) { rand(1..100) })
tree = Tree.new((Array.new(15) { rand(1..100) }))

# Confirm that the tree is balanced by calling #balanced?
puts '---Is the Tree balanced?---'
puts tree.balanced?

# Print out all elements in level, pre, post, and in order
puts "\nTree Traversal Methods\n\n"
puts '---Preorder Traversal---'
tree.preorder { |e| puts e }
puts '---Postorder Traversal---'
tree.postorder { |e| puts e }
puts '---Inorder Traversal---'
tree.inorder { |e| puts e }

# Unbalance the tree by adding several numbers > 100
tree.insert(101)
tree.insert(1000)
tree.insert(2000)
tree.insert(4000)

# Confirm that the tree is unbalanced by calling #balanced?
puts "\n---Is the Tree balanced?---"
puts tree.balanced?

# Balance the tree by calling rebalance
tree.rebalance

# Confirm that the tree is balanced by calling balanced?
puts "\n---Is the Tree balanced?---"
puts tree.balanced?

# Print out all elements in level, pre, post, and in order.
puts "\nTree Traversal Methods (Rebalanced Tree)\n\n"
puts '---Preorder Traversal---'
tree.preorder { |e| puts e }
puts '---Postorder Traversal---'
tree.postorder { |e| puts e }
puts '---Inorder Traversal---'
tree.inorder { |e| puts e }
