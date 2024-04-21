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
class Tree
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

  end

  def delete(value, node = root)
    # Traverse the tree and delete the value

  end

  def find(value, node = root)
    node if node.data == value
  end

  def level_order(node = root, &block)
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
end
