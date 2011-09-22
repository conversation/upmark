class Array
  def map_with_index
    result = []
    each_with_index do |element, index|
      result << yield(element, index)
    end
    result
  end
end
