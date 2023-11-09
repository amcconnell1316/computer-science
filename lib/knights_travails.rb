class Node
    attr_accessor :data, :children, :parent
  
    def initialize(data = nil, children = [], parent = nil)
      super()
      @data = data
      @children = children
      @parent = parent
    end

  end

  class Tree 
    def initialize()
      super()
      @root = nil
    end

    def insert(square, parent_node)
      new_node = Node.new(square) 
      if @root.nil?
        @root = new_node
      else
        new_node.parent = parent_node
        parent_node.children << new_node
      end
      new_node
    end

  end

  def knight_moves(start_square, target_square)
    puts "out of bounds" if !(on_board(start_square) && on_board(target_square))

    target_node = find_target_square(start_square, target_square)
    parents = parents(target_node)
    puts "You made it in #{parents.length} moves!  Here's your path:"
    while !parents.empty?
      node = parents.pop
      puts "[#{node.data[0]}, #{node.data[1]}]"
    end
    puts "[#{target_square[0]}, #{target_square[1]}]"
  end

  def find_target_square(start_square, target_square)
    moves = [[1, 2], [1, -2], [2, 1], [2, -1], [-1, 2], [-1, -2], [-2, 1], [-2, -1]]
    tree = Tree.new
    queue = [tree.insert(start_square, nil)]
    prev_moves = [start_square]
    while !queue.empty?
      current_node = queue.shift
      return current_node if current_node.data.eql?(target_square)
      
      moves.each do |move|
        new_square = [move[0] + current_node.data[0], move[1] + current_node.data[1]]
        break if !on_board(new_square) || prev_moves.include?(new_square)
 
        queue << tree.insert(new_square, current_node)
        prev_moves << new_square
      end
    end
  end

  def parents(node)
    parent_array = []
    while !node.parent.nil?
      parent_array << node.parent
      node = node.parent
    end
    parent_array
  end

  def on_board(square)
    square[0] >= 0 && square[0] <= 7 && square[1] >=0 && square[1] <=7
  end

  knight_moves([3,3],[4,3])
