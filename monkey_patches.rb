
# Patch Array and Hash for depth rendering

class Array
  def depth(max_depth)
    if (max_depth < 0)
      [nil]
    else
      self.collect { |value| value.respond_to?(:depth) ? value.depth(max_depth-1) : value }
    end
  end
end

class Hash
  def depth(max_depth)
    if (max_depth < 0)
      nil
    else
      self.inject({}) { |memo, (key, value)| memo[key] = value.respond_to?(:depth) ? value.depth(max_depth-1) : value }
    end
  end
end