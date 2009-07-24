
# Patch Array and Hash for depth rendering

class Array
  def depth(max_depth, options={})
    if (max_depth < 0)
      [nil]
    else
      self.collect { |value| value.respond_to?(:depth) ? value.depth(max_depth-1, options) : value }
    end
  end
end

class Hash
  def depth(max_depth, options={})
    if (max_depth < 0)
      nil
    else
      self.inject({}) do |memo, (key, value)| 
        memo[key] = if value.respond_to?(:depth)
          value.depth(max_depth-1, options)
        else
          value
        end
        memo
      end
    end
  end
end