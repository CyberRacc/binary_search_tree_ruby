# frozen-string-literal: true

# Node class for creating nodes in the tree
class Node
  include Comparable

  attr_accessor :data, :left_children, :right_children

  def initialize(data)
    @data = data
    @left_children = nil
    @right_children = nil
  end
end

# Tree class for creating a binary tree
# and performing operations on it
class Tree # rubocop:disable Metrics/ClassLength
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  # Recursive method to insert a node in the tree
  def build_tree(array)
    return nil if array.empty?

    array = array.uniq.sort
    mid = array.length / 2 # Find the middle element of the array
    root = Node.new(array[mid]) # Create a node with the middle element
    root.left_children = build_tree(array[0...mid]) # Recursively build the left subtree
    root.right_children = build_tree(array[mid + 1..]) # Recursively build the right subtree
    root # Return the node
  end

  def pretty_print(node = root, prefix = '', is_left = true)
    pretty_print(node.right_children, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_children
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_children, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_children
  end

  def insert(value, node = root)
    # Traverse the tree and insert the value

    return Node.new(value) if node.nil?

    if node.data < value
      node.right_children = insert(value, node.right_children)
    else
      node.left_children = insert(value, node.left_children)
    end
    node
  end

  def delete(value, node = root) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    return node if node.nil?

    if value < node.data
      node.left_children = delete(value, node.left_children)
    elsif value > node.data
      node.right_children = delete(value, node.right_children)
    else
      # node with only one child or no child
      if node.left_children.nil?
        temp = node.right_children
        node = nil
        return temp
      elsif node.right_children.nil?
        temp = node.left_children
        node = nil
        return temp
      end

      # node with two children: get the inorder successor (smallest in the right subtree)
      temp = min_value_node(node.right_children)

      # copy the inorder successor's content to this node
      node.data = temp.data

      # delete the inorder successor
      node.right_children = delete(temp.data, node.right_children)
    end
    node
  end

  def min_value_node(node)
    current = node

    # loop down to find the leftmost leaf
    current = current.left_children until current.left_children.nil?

    current
  end

  def find(value, node = root)
    # Traverse the tree and return the node with the value
    return nil if node.nil?

    return node if node.data == value

    if node.data < value
      find(value, node.right_children)
    else
      find(value, node.left_children)
    end
  end

  def level_order(node = root)
    # Traverse the tree in breadth-first level order and yield each node to the block
    # Implement as recursion
    queue = [] # discovered nodes

    return if node.nil?

    queue << node
    until queue.empty?
      current = queue.shift
      yield current if block_given?
      queue << current.left_children unless current.left_children.nil?
      queue << current.right_children unless current.right_children.nil?
    end
  end

  # Each of the below methods, inorder, preorder, and postorder
  # should traverse the tree in their respective depth-first order
  # and yield each node to the block
  # The methods should return an array of values if no block is given

  def inorder(node = root, &block)
    # Base case: if the node is nil, return an empty array
    return [] if node.nil?

    # If no block is given, return an array of values in inorder traversal order
    return inorder(node.left_children, &block) + [node.data] + inorder(node.right_children, &block) unless block_given?

    # If a block is given, recursively traverse the left subtree, yield the current node to the block,
    # and then recursively traverse the right subtree
    inorder(node.left_children, &block)
    yield node
    inorder(node.right_children, &block)
  end

  def preorder(node = root, &block)
    # Base case: if the node is nil, return an empty array
    return [] if node.nil?

    # If no block is given, return an array of values in preorder traversal order
    unless block_given?
      return [node.data] + preorder(node.left_children, &block) + preorder(node.right_children, &block)
    end

    # If a block is given, yield the current node to the block,
    # and then recursively traverse the left subtree and the right subtree
    yield node
    preorder(node.left_children, &block)
    preorder(node.right_children, &block)
  end

  def postorder(node = root, &block)
    # Base case: if the node is nil, return an empty array
    return [] if node.nil?

    # If no block is given, return an array of values in postorder traversal order
    unless block_given?
      return postorder(node.left_children, &block) + postorder(node.right_children, &block) + [node.data]
    end

    # If a block is given, recursively traverse the left subtree, recursively traverse the right subtree,
    # and then yield the current node to the block
    postorder(node.left_children, &block)
    postorder(node.right_children, &block)
    yield node
  end

  # height method, accepts a node and returns its height.
  # Height is defined as the number of edges in the longest path from the node to a leaf node.
  def height(node = root)
    # Base case: if the node is nil (i.e., the tree is empty or we've reached a leaf), return -1
    return -1 if node.nil?

    # Recursive case: calculate the height of the left and right subtrees, take the maximum,
    # and add 1 for the current node. This effectively calculates the height of the tree.
    [height(node.left_children), height(node.right_children)].max + 1
  end

  # depth method, accepts a node and returns its depth.
  # Depth is defined as the number of edges in path from a given node to the tree's root node
  def depth(node = root, current = root, depth = 0)
    # Base case: if the current node is nil, return -1
    return -1 if current.nil?

    # If the current node is the same as the node we're looking for, return the depth
    return depth if current == node

    # Recursive case: increment the depth and search the left and right subtrees
    left = depth(node, current.left_children, depth + 1)
    right = depth(node, current.right_children, depth + 1)

    # If the node is not found in either subtree, return -1
    left == -1 ? right : left
  end

  # balanced? method, accepts a node and returns true if the tree is balanced
  # A balanced tree is defined as a tree where the height of the left subtree and the height of the right subtree differ by at most 1
  # The method should return false if the tree is unbalanced
  def balanced?(node = root)
    # Base case: if the node is nil, return true
    return true if node.nil?

    # Recursive case: check if the left subtree is balanced, check if the right subtree is balanced,
    # and check if the difference in height is at most 1
    left = height(node.left_children)
    right = height(node.right_children)

    return true if (left - right).abs <= 1 && balanced?(node.left_children) && balanced?(node.right_children)

    false
  end

  # rebalance method, rebalances an unbalanced tree
  # The method should return a balanced tree
  # The method should work by converting the tree to an array, sorting the array, and then building a new tree from the sorted array
  def rebalance
    # Convert the tree to an array, sort the array, and then build a new tree from the sorted array
    array = inorder
    @root = build_tree(array)
  end
end
