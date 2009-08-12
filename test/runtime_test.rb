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

  test "creates the runtime's dir" do
    Rip::Runtime.add('ruby')
    assert File.exists?(Rip::Runtime.runtime_dir(Rip::Runtime.which('ruby')))
  end
end

context "Activating a runtime" do
  setup_with_fs do
    @active_dir = File.join(Rip.dir, 'active')
    @name = 'new_env'
    @ripenv = File.join(Rip.dir, @name)
    assert !File.exists?(@ripenv)
    Rip::Env.use('new_env')
    Rip::Runtime.manager = Rip::PackageManager.new
    @runtime = Rip::Runtime.which('ruby')
  end

  test "passes if the runtime has been added" do
    assert_equal "added #{@runtime} runtime", Rip::Runtime.add('ruby')
    assert_equal "#{@runtime} is active", Rip::Runtime.use('ruby')
  end

  test "fails if the runtime cannot be found" do
    assert_equal '', `which '/not/a/valid/ruby'`.chomp
    assert_equal "/not/a/valid/ruby runtime not found", Rip::Runtime.use('/not/a/valid/ruby')
  end

  test "adds the runtime if it has not been added" do
    assert !Rip::Runtime.runtimes.include?(@runtime)
    Rip::Runtime.use @runtime
    assert Rip::Runtime.runtimes.include?(@runtime)
  end

  test "moves the runtime to the head of the runtimes" do
    Rip::Runtime.use @runtime
    assert_equal @runtime, Rip::Runtime.runtimes.first
  end

  test "symlinks ext to the runtime dir" do
    Rip::Runtime.use @runtime
    assert File.exists?(Rip::Runtime.ext_link)
  end
end