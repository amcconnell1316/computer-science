def merge_sort(array)
  return array if array.length == 1

  #break apart array
  mod = array.length/2
  
  #sort left side
  left_array = merge_sort(array[0..mod-1])

  #sort right side
  right_array = merge_sort(array[mod..array.length-1])

  #merge arrays
  sorted_array = []
  right_index = 0
  left_array.each do | left_element |
    while right_index < right_array.length && left_element > right_array[right_index]
      sorted_array << right_array[right_index]
      right_index += 1
    end
    sorted_array << left_element
  end
  while right_index < right_array.length do
    sorted_array << right_array[right_index]
      right_index += 1
  end
  sorted_array
end

p [1,2,3]
p merge_sort([5,2,1,4,6,0,3])
p merge_sort([1,2,3])
p merge_sort([3,2,1])
p merge_sort([9,7,5,8,6,4,3])