require 'helper'

class TestNoSuchFactoryException < Test::Unit::TestCase

  should "be a subclass of ArgumentError" do
    assert NoSuchFactoryException.new.kind_of? ArgumentError
  end

end