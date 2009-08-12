$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
require 'test_helper'

context "Adding a runtime" do
  setup_with_fs do
    @active_dir = File.join(Rip.dir, 'active')
    @name = 'new_env'
    @ripenv = File.join(Rip.dir, @name)
    assert !File.exists?(@ripenv)
    Rip::Env.use('new_env')
    Rip::Runtime.manager = Rip::PackageManager.new
  end

  test "passes if the provided a new runtime" do
    assert_not_equal '', runtime = `which 'ruby'`.chomp
    assert_equal "added #{runtime} runtime", Rip::Runtime.add('ruby')
  end

  test "fails if the runtime cannot be found" do
    assert_equal '', `which '/not/a/valid/ruby'`.chomp
    assert_equal "/not/a/valid/ruby runtime not found", Rip::Runtime.add('/not/a/valid/ruby')
  end

  test "fails if the same runtime is added twice" do
    runtime = Rip::Runtime.which('ruby')
    assert_equal "added #{runtime} runtime", Rip::Runtime.add(runtime)
    assert_equal "#{runtime} runtime already added", Rip::Runtime.add('ruby')
  end
end