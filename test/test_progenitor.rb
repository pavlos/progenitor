require 'helper'

class TestProgenitor < Test::Unit::TestCase

  should "not fail" do
    Factory :foo
  end

  should "produce an instance of foo" do
    foo = Factory :foo
    assert foo.instance_of? Foo
  end

  should "raise exception if not found" do
    assert_raise NoSuchFactoryException do
      Factory :nothing
    end
  end

  should "pass along params" do
    Progenitor::Factory.factories[:something_that_takes_args].expects(:call).with(:foo, :bar)
    Factory :something_that_takes_args, :foo, :bar
  end

  should "pass along block" do
    result = Factory :something_that_takes_args_and_a_block, :foo, :bar do
      :return_value
    end
    assert_equal :return_value, result
  end

  context "factory with a sequence" do
    setup do
      # need to reload this to reset the sequence
      load 'foo_factory.rb'
    end

    context "numbered foo" do
      should "produce a numbered object" do
        foo = Factory :numbered_foo
        assert_equal 0, foo.id
      end

      should "maintain its value between invocations" do
        foo = Factory :numbered_foo
        assert_equal 0, foo.id
        foo = Factory :numbered_foo
        assert_equal 1, foo.id
      end
    end

    context "doubly numbered foo" do
      should "produce a doubly numbered object" do
        foo = Factory :doubly_numbered_foo
        assert_equal 0, foo.id
        assert_equal foo.id, foo.id2
      end
    end
  end

  context "when used with FactoryGirl" do

    should "delegate to factory girl if it is loaded" do
      ::Factory = mock('factory girl') do
        expects(:respond_to?).with(:default_strategy).returns(true)
        expects(:default_strategy).with :non_existant_factory
      end

      Factory :non_existant_factory
    end

    teardown do
      Object.send :remove_const, "Factory"
    end

  end

end
