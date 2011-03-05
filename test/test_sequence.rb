require 'helper'

class TestSequence < Test::Unit::TestCase

  context "a sequence built with no args" do
    setup do
      @sequence = Progenitor::Sequence.new
    end
    context "next_int" do
      should "start at zero by default" do
        assert_equal 0, @sequence.next_int
      end

      should "go up by one each time it is called" do
        assert_equal 0, @sequence.next_int
        assert_equal 1, @sequence.next_int
        assert_equal 2, @sequence.next_int
        assert_equal 3, @sequence.next_int
      end

      should "synchronize next_int on a mutex" do
        Mutex.any_instance.expects(:synchronize)
        @sequence.next_int
      end

      should "start where in_sequence left off" do
        @sequence.in_sequence{}
        assert_equal 1, @sequence.next_int
      end
    end

    context "in_sequence" do

      should "yield to its block, starting at 0" do
        @sequence.in_sequence do |i|
          assert_equal 0, i
        end
      end

      should "increment its sequence number on a successive invocation" do
        @sequence.in_sequence {}
        @sequence.in_sequence do |i|
          assert_equal 1, i
        end
      end

      should "start where next_int left off" do
        @sequence.next_int
        @sequence.in_sequence do |i|
          assert_equal 1, i
        end
      end

      should "release its lock before calling the block" do
        @sequence.send(:lock).expects(:lock)
        @sequence.in_sequence do
          assert_false @sequence.send(:lock).locked?
        end
      end
    end
  end

  context "a sequence with a starting value specified" do
    setup do
      @sequence = Progenitor::Sequence.new 42
    end

    should "start at that value" do
      assert_equal 42, @sequence.next_int
    end

    should "go up by one each time it is called" do
      assert_equal 42, @sequence.next_int
      assert_equal 43, @sequence.next_int
      assert_equal 44, @sequence.next_int
      assert_equal 45, @sequence.next_int
    end
  end
end