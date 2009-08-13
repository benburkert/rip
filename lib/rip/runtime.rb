module Rip
  module Runtime
    extend self
    extend Help
    extend Forwardable

    attr_writer   :manager
    def_delegator :manager, :runtimes

    o 'rip runtime add RUBY'
    x 'Add a new ruby.'
    def add(ruby)
      runtime = which ruby
      return "#{ruby} runtime not found" if runtime.empty?
      return "#{runtime} runtime already added" if runtimes.include? runtime

      runtimes.push runtime

      FileUtils.mkdir_p runtime_dir(runtime)
      build_extensions runtime

      manager.save
      "added #{runtime} runtime"
    end

    o 'rip runtime use RUBY'
    x 'Activate a runtime.'
    def use(ruby)
      runtime = which ruby
      return "#{ruby} runtime not found" if runtime.empty?

      add runtime unless runtimes.include? runtime
      activate runtime

      "#{runtime} is active"
    end

    o 'rip runtime active'
    x 'Show the active runtime'
    def active
      runtimes.first
    end

    o 'rip runtime list'
    x 'List all installed runtimes'
    def list
      runtimes.sort.map {|runtime| runtime << (" (active)" if active == runtime) }.join("\n")
    end

    o 'rip runtime delete RUBY'
    x 'Remove a ruby runtime'
    def delete(ruby)
      runtime = which ruby
      return "#{ruby} runtime not found" if runtime.empty?

      deactivate runtime
      FileUtils.rm_rf runtime_dir(runtime)

      "#{runtime} runtime deleted"
    end

    def commands
      %w( add use active list delete )
    end

    def call(meth, *args)
      arity = method(meth).arity.abs

      if arity == args.size
        send(meth, *args)
      elsif arity == 0
        send(meth)
      elsif args.empty?
        send(meth, '')
      else
        send(meth, *args[0, arity])
      end
    end

    def activate(runtime)
      runtimes.delete runtime
      runtimes.unshift runtime

      symlink runtime
    end

    def build_extensions(runtime)
      Rip::Commands.build({:runtimes => runtime}, *manager.package_names)
    end

    def deactivate(runtime)
      runtimes.delete runtime
      activate active unless active.nil?
    end

    def ext_link
      File.join(Env.active_dir, 'ext')
    end

    def manager
      @manager ||= PackageManager.new(Rip::Env.active)
    end

    def runtime_dir(runtime)
      File.join(runtimes_dir, File.basename(runtime) + '-' + Digest::MD5.hexdigest(runtime))
    end

    def runtimes_dir
      File.join(Env.active_dir, 'rip-runtimes')
    end

    def symlink(runtime)
      FileUtils.rm ext_link rescue Errno::ENOENT
      FileUtils.ln_s runtime_dir(runtime), ext_link
    end

    def which(ruby)
      path = `which '#{ruby}'`.chomp
      path.empty? ? '' : File.expand_path(path)
    end
  end
end