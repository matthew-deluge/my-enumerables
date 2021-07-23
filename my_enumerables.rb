# frozen_string_literal: true
array = [1, 2, 3, 4, 5]
hash = {
  :numbera => 1,
  :numberb => 2
}


module Enumerable
  def my_each
    i = 0
    until length == i
      if is_a?(Hash)
        yield keys[i], values[i]
      else
        yield self[i]
      end
      i += 1
    end
    self
  end

  # calls block with two arguments, the item and its index
  def my_each_with_index 
    i = 0
    until length == i
      yield self[i], i
      i += 1
    end
    self
  end

  # returns an array with all elements that return true when passed to block
  def my_select 
    arr = []
    my_each { |element| arr << element if yield element }
    arr
  end

  # returns true if the block never returns false or nil when called on each element
  def my_all?
    if block_given?
      my_each { |element| return false unless yield(element) }
    else
      my_each { |element| return false if element.false? || element.nil? }
    end
    true
  end

  # returns true if element passed to block returns a value other than false or nil
  def my_any? 
    if block_given?
      my_each { |element| return true if yield(element) }
    else
      my_each { |element| return true unless element.false? || element.nil? }
    end
    false
  end

  # returns true if no element returned to block returns true
  def my_none? 
    if block_given?
      my_each { |element| return false if yield(element) }
    else
      my_each { |element| return false if element.true? }
    end
    true
  end

  # returns number of items, or number of passed element, or number of elements returning a true value
  def my_count(arg = nil)
    count = 0
    if block_given?
      my_each { |element| count+=1 if yield(element) }
    elsif !arg.nil?
      my_each { |element| count+=1 if element == arg }
    else
      count = length
    end
    count
  end

  # returns a new array with the results of running the block once for each element
  def my_map 
    if block_given?
      arr = []
      my_each { |element| arr << yield(element) }
      arr
    else
      self
    end
  end
  
  # combines all elements by applying a binary operation
  def my_inject
     
  end

end

# my_each test

puts "testing my_each on array..."
array.each { |number| puts number + 1 }
array.my_each { |number| puts number + 1 }

puts 'testing my each on hash'
hash.each { |symbol, number| puts number + 1}
hash.my_each { |symbol, number| puts number + 1 }

puts 'testing my_each_with_index'
puts '#each_with_index returns:'
array.each_with_index { |number, index| puts "number: #{number}, index #{index}"}
puts '#my_each_with_index returns:'
array.each_with_index { |number, index| puts "number: #{number}, index #{index}"}

puts 'testing my_select'
their_select_array = array.select { |number| number.even? }
my_select_array = array.my_select { |number| number.even? }
puts "their result: #{ their_select_array }"
puts "my result: #{ my_select_array }"
puts "result is #{their_select_array == my_select_array}"

puts 'testing my_all'
puts 'testing if true...'
puts (array.all? {|number| number < 6 })
puts (array.my_all? { |number| number < 6 })
puts 'testing if false...'
puts (array.all? { |number| number < 5 })
puts (array.my_all? { |number| number < 5 })

puts 'testing my_any?'
puts 'testing if true...'
puts (array.any? {|number| number == 4 })
puts (array.my_any? { |number| number == 4 })
puts 'testing if false...'
puts (array.any? { |number| number == 7 })
puts (array.my_any? { |number| number == 7 })

puts 'testing my_none?'
puts 'testing if true...'
puts (array.none? {|number| number == 7 })
puts (array.my_none? { |number| number == 7 })
puts 'testing if false...'
puts (array.none? { |number| number == 4 })
puts (array.my_none? { |number| number == 4 })

puts 'testing my_count...'
puts "works with a block: #{array.my_count {|number| number.even?} == 2}"
puts "works with an argument: #{ array.my_count(2) == 1} "
puts "works with nothing passed: #{ array.my_count == 5} "

puts 'testing my_map...'
print (array.map { |number| number + 1 })
print (array.my_map { |number| number +1 })