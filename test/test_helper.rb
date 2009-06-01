$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'rip'
Rip.dir = File.expand_path(File.join(File.dirname(__FILE__), 'ripdir'))

def autoload_all(namespace)
  namespace.constants.each do |c|
    const = namespace.module_eval c
    autoload_all(const) if const.is_a? Module
  end
end

autoload_all Rip

require 'fakefs'
require 'test/unit'
require 'test/spec/mini'

begin
  require 'redgreen'
rescue LoadError
end

class Test::Unit::TestCase
  def self.setup_with_fs(&block)
    define_method :setup do
      FakeFS::FileSystem.clear
      Rip::Env.create('other')
      Rip::Env.create('base')
      setup_block
    end

    define_method(:setup_block, &block)
  end
end
