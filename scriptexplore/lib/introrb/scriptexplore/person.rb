module Introrb; end
module Introrb::Scriptexplore; end

class Introrb::Scriptexplore::Person
  attr_accessor :name, :age
  
  def initialize(name = 'World', age = 0)
    @name, @age = name, age
  end
  
  def ==(other)
    other.is_a?(self.class) && name == other.name && age == other.age
  end
  
  def hash
    to_s.hash
  end
  
  def to_s
    "Person{'name': #{name}, 'age': #{age}}"
  end
end
