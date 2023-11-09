class BTNode
include Comparable
  attr_accessor :data, :right, :left

  def initialize(data = nil, left = nil, right = nil)
    super()
    @data = data
    @left = left
    @right = right
  end

  def <=>(other_node)
    @data <=> other_node.data
  end
end

class BSTree

  def initialize(array)
    @root = build_tree(array)    
  end

  def build_tree(array)
    return nil if array.nil? || array.empty?

    sorted_array = array.uniq.sort
    mid = sorted_array.length/2
    root = BTNode.new(sorted_array[mid])
    root.left = build_tree(sorted_array[0..mid-1]) unless mid-1 < 0
    root.right = build_tree(sorted_array[mid+1..sorted_array.length]) unless mid+1 > sorted_array.length
    root
  end

  def insert(value)
    new_node = BTNode.new(value)
    next_node = @root
    duplicate = false
    stop = false
    while !stop
      search_node = next_node
      duplicate = search_node == new_node
      next_node = search_node > new_node ? search_node.left : search_node.right
      stop = next_node.nil? || duplicate
    end

    return if duplicate

    if search_node > new_node
      search_node.left = new_node
    else
      search_node.right = new_node
    end

  end

  #From odin project
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

test = BSTree.new([2,4,5,6,7,2,34,6,7,4,0])
test.insert(1)
test.insert(8)
test.insert(35)
test.pretty_print