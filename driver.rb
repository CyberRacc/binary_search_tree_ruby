# frozen-string-literal: true

require './lib/tree'

# Create a binary tree
tree = Tree.new(Array.new(15) { rand(1..100) })

# Check and print balance status
puts tree.balanced? ? 'Tree is balanced' : 'Tree is not balanced'

# Print out all elements i a level, pre, post, and in order
puts 'Level order:'
tree.level_order { |node| print "#{node.data} " }
puts "\nPreorder:"
tree.preorder { |node| print "#{node.data} " }
puts "\nPostorder:"
tree.postorder { |node| print "#{node.data} " }
puts "\nInorder:"
tree.inorder { |node| print "#{node.data} " }
puts "\n\n"

# Unbalance the tree by adding several numbers to it
5.times { tree.insert(rand(101..200)) }

# Check and print balance status
puts tree.balanced? ? 'Tree is balanced' : 'Tree is not balanced'

# Balance the tree
tree.rebalance

# Check and print balance status
puts tree.balanced? ? 'Tree is balanced' : 'Tree is not balanced'

# Print out all elements i a level, pre, post, and in order
puts 'Level order after rebalancing:'
tree.level_order { |node| print "#{node.data} " }
puts "\nPreorder after rebalancing:"
tree.preorder { |node| print "#{node.data} " }
puts "\nPostorder after rebalancing:"
tree.postorder { |node| print "#{node.data} " }
puts "\nInorder after rebalancing:"
tree.inorder { |node| print "#{node.data} " }
puts "\n\n"

# Print the tree
tree.pretty_print
puts "\n\n"
