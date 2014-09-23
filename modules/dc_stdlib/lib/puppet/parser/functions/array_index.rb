# Inputs:
#   1st argument: Array in which we search for the element
#   2nd argument: element to be seearched for in the Array
#
# Returned values:
#   -1: element not found
#   otherwise: position of the element in the array (starting at index 0)
#
# Raised errors:
#   Puppet::ParseError: if 1st element is not an Array
#   Puppet::ParseError: if element is not found in the array
#
require 'fileutils'
module Puppet::Parser::Functions
  newfunction(:array_index, :type => :rvalue) do |args|
    unless args[0].class == Array then
      raise Puppet::ParseError, 'array_index(): 1st argument must be an array'
    end

    in_array = args[0]
    searched_elt = args[1]
    res = in_array.index searched_elt
    return res
end
end
