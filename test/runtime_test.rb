$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
require 'test_helper'

context "Adding a runtime" do
  test "fails if the runtime cannot be found" do
    assert_equal '', `which '/not/a/valid/ruby'`.chomp
    assert_equal "/not/a/valid/ruby runtime not found", Rip::Runtime.add('/not/a/valid/ruby')
  end
end