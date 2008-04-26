class String

  def to_snake!
    while x = index(/([a-z\d])([A-Z])/)
      y = x + 1
      self[x..y] = self[x..x]+"_"+self[y..y].downcase
    end
    self
  end
  
  def to_camel!
    while x = index("_")
      y = x + 1
      self[x..y] = self[y..y].capitalize
    end
    self
  end
  
  def to_title
   title = self.dup
   title[0..0] = title[0..0].upcase
   title
  end
  
end