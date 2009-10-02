$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'test/unit'
require "scufl/model"
require "scufl/parser"
require "scufl/dot"

class BasicTest < Test::Unit::TestCase
  FIXTURES = File.join(File.dirname(__FILE__), "fixtures")
  FLOW_CONTENT = IO.read("#{FIXTURES}/coordinated.xml")
  
  def setup
    @model = Scufl::Parser.new.parse(FLOW_CONTENT)
  end
  
  def test_misc
    assert(@model.coordinations.size, 1)
    assert_equal(@model.processors.size, 2)
    assert(@model.sinks.empty?)
    assert(@model.sources.empty?)
    assert_equal(@model.dependencies, nil)
  end
end