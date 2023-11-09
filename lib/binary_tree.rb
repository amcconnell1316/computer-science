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

    return search_node if duplicate

    if search_node > new_node
      search_node.left = new_node
    else
      search_node.right = new_node
    end
    new_node
  end

  def delete(value)
    node_pair = find_with_parent(value)
    return if node_pair.nil?
    node_pair => [node_to_delete, parent_node]

    if node_to_delete.left.nil? && node_to_delete.right.nil?
      replace_node(parent_node, node_to_delete, nil)
    elsif node_to_delete.left.nil? ^ node_to_delete.right.nil?
      new_node = node_to_delete.left.nil? ? node_to_delete.right : node_to_delete.left
      replace_node(parent_node, node_to_delete, new_node)
    else
      leftmost_node = node_to_delete.right
      leftmost_parent = node_to_delete
      while !leftmost_node.left.nil?
        leftmost_parent = leftmost_node
        leftmost_node = leftmost_node.left
      end
      #Move any right tree of leftmost node up (deleting leftmost node from tree)
      #Right tree's children stay the same
      replace_node(leftmost_parent, leftmost_node, leftmost_node.right)
      #Move leftmost node as child of deleted nodes parents
      replace_node(parent_node, node_to_delete, leftmost_node)
      #Set leftmost node as parent of deleted nodes children
      leftmost_node.left = node_to_delete.left
      leftmost_node.right = node_to_delete.right
    end


  end

  def replace_node(parent_node, old_node, new_node)
    @root = new_node if parent_node.nil? 
    return if parent_node.nil?

    if parent_node.left == old_node
      parent_node.left = new_node
    else
      parent_node.right = new_node
    end
  end

  def find(value)
    found_pair = find_with_parent(value)
    found_pair.nil? ? nil : found_pair[0]
  end

  def find_with_parent(value)
    new_node = BTNode.new(value)
    next_node = @root
    search_node = nil
    found = false
    stop = false
    while !stop
      parent_node = search_node
      search_node = next_node
      found = search_node == new_node
      next_node = search_node > new_node ? search_node.left : search_node.right
      stop = next_node.nil? || found
    end
    return found ? [search_node, parent_node] : nil
  end

  def level_order
    queue = [@root]
    output = []
    while !queue.empty?
      next_node = queue.shift
      queue << next_node.left unless next_node.left.nil?
      queue << next_node.right unless next_node.right.nil?
      output << next_node.data
      yield(next_node) if block_given?
    end
    output
  end

  def inorder(node = @root, output = [], &block)
    inorder(node.left, output, &block) unless node.left.nil?
    output << node.data
    block.call(node) if block_given?
    inorder(node.right, output, &block) unless node.right.nil?
    output
  end

  def preorder(node = @root, output = [], &block)
    output << node.data
    block.call(node) if block_given?
    preorder(node.left, output, &block) unless node.left.nil?
    preorder(node.right, output, &block) unless node.right.nil?
    output
  end

  def postorder(node = @root, output = [], &block)
    postorder(node.left, output, &block) unless node.left.nil?
    postorder(node.right, output, &block) unless node.right.nil?
    output << node.data
    block.call(node) if block_given?
    output
  end

  def height(node = @root, current_depth = 0)
    max_left_depth = node.left.nil? ? current_depth : height(node.left, current_depth + 1)
    max_right_depth = node.right.nil? ? current_depth : height(node.right, current_depth + 1) 
    max_left_depth > max_right_depth ? max_left_depth : max_right_depth
  end

  def depth(node)
    found_depth = depth_search(@root, node, 0)
    return nil if found_depth == 0 && @root != node
    found_depth    
  end

  def depth_search(current_node, search_node, current_depth)
    return current_depth if current_node == search_node
    left_depth = current_node.left.nil? ? 0 : depth_search(current_node.left, search_node, current_depth + 1) 
    right_depth = current_node.right.nil? ? 0 : depth_search(current_node.right, search_node, current_depth +1)  
    left_depth > right_depth ? left_depth : right_depth
  end

  def balanced?
    balanced_inner(@root, 0) => [_, is_balanced]
    is_balanced
  end

  def balanced_inner(node, current_depth)
    node.left.nil? ? [current_depth, true] : balanced_inner(node.left, current_depth + 1) => [max_left_depth, left_balanced]
    node.right.nil? || !left_balanced ? [current_depth, true] : balanced_inner(node.right, current_depth + 1) => [max_right_depth, right_balanced]
    node_balanced = (max_left_depth == max_right_depth || max_left_depth +1 == max_right_depth || max_left_depth -1 == max_right_depth) && left_balanced && right_balanced
    [max_left_depth > max_right_depth ? max_left_depth : max_right_depth, node_balanced]
  end

  def rebalance
    array = self.inorder
    @root = build_tree(array)
  end

  #From odin project
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

test = BSTree.new([2,4,5,6,7,2,6,7,4,0])
puts test.balanced?
test.insert(1)
test.insert(8)
test.insert(50)
test.insert(30)
node_60 = test.insert(60)
test.insert(70)
test.insert(65)
node_72 = test.insert(72)
#test.pretty_print

test.delete(4)
test.delete(0)
test.delete(50)
test.pretty_print
test.rebalance
test.pretty_print
# p test.level_order
# #test.level_order {|node| puts node.data * 2}
# p test.inorder
# #test.inorder {|node| puts node.data * 2}
# p test.preorder
# #test.preorder {|node| puts node.data * 2}
# p test.postorder
# #test.postorder {|node| puts node.data * 2}
# puts test.height
# puts test.height(node_60)
# puts test.height(node_72)
# puts test.depth(node_60)
# puts test.depth(node_72)
# p test.depth(BTNode.new(100))
# puts test.balanced?