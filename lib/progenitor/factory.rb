require 'progenitor/no_such_factory_exception'

module Progenitor
  class Factory

    @@factories = {}

    def self.factories
      @@factories
    end

    def self.create(name, &block)
      @@factories[name] = block
    end

  end
end

def Factory(*args, &block)
  if Progenitor::Factory.factories.has_key? args[0]
    name = args.shift
    Progenitor::Factory.factories[name].call(*args, &block)
  elsif defined?(::Factory) && (::Factory.respond_to? :default_strategy) #use along side Factory Girl
    ::Factory.default_strategy *args, &block
  else
    raise NoSuchFactoryException, "You haven't defined a factory called #{args[0]}"
  end
end