class Node
  attr_accessor :next_node, :value

  def initialize(value = nil, next_node = nil)
    super()
    @value = value
    @next_node = next_node
  end
end

class LinkedList
  attr_reader :size

  def initialize
    super()
    @head_node = nil
    @size = 0
  end

  def append(value)
    new_node = Node.new(value)
    last_node = tail
    if last_node.nil?
      @head_node = new_node
    else
      last_node.next_node = new_node
    end
    @size += 1
  end

  def prepend(value)
    new_node = Node.new(value, @head_node)
    @head_node = new_node
    @size += 1
  end

  def head
    @head_node
  end

  def tail
    return nil if @head_node.nil?

    search_node = @head_node
    while !search_node.next_node.nil?
      search_node = search_node.next_node
    end
    return search_node
  end

  def at(index)
    return nil if @head_node.nil? || index >= @size

    search_node = @head_node
    count = 0
    while count < index
      count += 1
      search_node = search_node.next_node
    end
    search_node
  end

  def pop
    return_node = tail
    @size -=1 unless return_node.nil?
    return_node
  end

  def contains?(value)
    return find(value).nil? ? false : true 
  end

  def find(value)
    return nil if @head_node.nil?

    search_node = @head_node
    while !search_node.nil? && search_node.value != value
      search_node = search_node.next_node
    end
    return search_node.nil
  end

  def to_s
    return 'nil' if @head_node.nil?

    return_string = ''
    search_node = @head_node
    while !search_node.nil?
      return_string += "( #{search_node.value} ) -> "
      search_node = search_node.next_node
    end
    return_string += 'nil'
    return_string
  end
end

empty = LinkedList.new
single = LinkedList.new
two = LinkedList.new
three = LinkedList.new
four = LinkedList.new

#append
single.append(1)
two.append(2)
four.append(3)
four.append(4)
#prepend
two.prepend(1)
three.prepend(2)
three.append(3)
three.prepend(1)
four.prepend(2)
four.prepend(1)
four.append(5)

#size
puts empty.size
puts single.size
puts two.size
puts three.size

#head
puts empty.head
puts single.head.value
#tail
puts two.tail.value
puts three.tail.value
#at
puts three.at(0).value
puts two.at(1).value
puts single.at(0).value
puts three.at(2).value
puts three.at(3)
puts empty.at(0)
#pop
puts empty.pop
puts empty.size
puts four.pop.value
puts four.size

#contains?
#find
#to_s
puts empty.to_s
puts single.to_s
puts two.to_s
puts three.to_s
puts four.to_s