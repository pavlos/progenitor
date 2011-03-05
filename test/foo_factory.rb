class FooFactory < Progenitor::Factory

  create :foo do
    foo = Foo.new
    foo
  end

  @i = Progenitor::Sequence.new
  create :numbered_foo do
    foo = Foo.new
    foo.id = @i.next_int
    foo
  end

  @j = Progenitor::Sequence.new
  create :doubly_numbered_foo do
    foo = Foo.new
    @j.in_sequence do |i|
      foo.id = i
      foo.id2 = i
    end
    foo
  end

  create :something_that_takes_args do |*args|

  end
  
  create :something_that_takes_args_and_a_block do |*args, &block|
    block.call
  end

end