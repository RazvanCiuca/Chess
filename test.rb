class Test
  attr_accessor :name
  def initialize
    @name = ["fluffy","puffy","huffy"].sample
  end
end

c = [[Test.new, Test.new], [Test.new, Test.new]]

d = c.to_yaml
d = YAML.load(d)